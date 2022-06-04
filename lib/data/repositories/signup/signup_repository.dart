import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignupRepository {
  Future registerStaff({
    required String name,
    required String email,
    required String phone,
  }) async {
    var res =
        await FirebaseFirestore.instance.collection("staffs").doc(email).get();
    if (res.exists && res.data()!["email"] != null) {
    } else {
      await FirebaseFirestore.instance.collection("staffs").doc(email).set({
        "name": name,
        "search_name": name.toLowerCase(),
        "email": email,
        "phone": phone,
        "status": "inactive",
        "enrollment_key": [],
        "created_on": DateTime.now().toString(),
      });
    }
  }

  Future updateStaff(Map<String, dynamic> staff) async {
    await FirebaseFirestore.instance
        .collection("staffs")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update(staff);
  }

  Future<void> signUpWithGoogle({
    required String name,
    required String phone,
  }) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // sign in with google account

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((e) {
        throw Exception("authentication_failure");
      });

      if (userCredential.user != null && userCredential.user!.email != null) {
        await registerStaff(
            name: name, email: userCredential.user!.email!, phone: phone);
      } else {
        throw Exception("Something went woring");
      }

      //storing user data because of signup

    } else {
      throw Exception("No Google account selected!");
    }
  }

  Future<void> signUpWithApple({
    required String phone,
    required String name,
  }) async {
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
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        await registerStaff(
            name: userCredential.user?.displayName ?? "",
            email: userCredential.user?.email ?? "",
            phone: phone);
      } else {
        throw Exception("Something went woring");
      }
    } else {
      throw Exception("No Apple account selected!");
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
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
