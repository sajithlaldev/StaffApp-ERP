import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/staff.dart';

class LoginRepository {
  static Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found!');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password!');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<Staff?> fetchStaff() async {
    var res = (await FirebaseFirestore.instance
        .collection("staffs")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get());

    return res.exists ? Staff.fromMap(res.data() ?? {}) : null;
  }

  Future<Staff?> fetchStaffFromId(String email) async {
    var res = (await FirebaseFirestore.instance
        .collection("staffs")
        .doc(email)
        .get());

    return res.exists ? Staff.fromMap(res.data() ?? {}) : null;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Staff? staff = await fetchStaffFromId(userCredential.user!.email!);

      if (staff != null && staff.email.isNotEmpty) {
        return userCredential;
      } else {
        await GoogleSignIn().signOut();
        throw Exception("Not registered. Please Signup first");
      }
      // Once signed in, return the UserCredential
    } else {
      throw Exception("No Google account selected!");
    }
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    if (appleCredential.identityToken != null) {
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      Staff? staff = await fetchStaffFromId(userCredential.user?.email ?? "");

      if (staff != null && staff.email.isNotEmpty) {
        return userCredential;
      } else {
        await FirebaseAuth.instance.signOut();
        throw Exception("Not registered. Please Signup first");
      }
    } else {
      throw Exception("No Apple account selected!");
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
