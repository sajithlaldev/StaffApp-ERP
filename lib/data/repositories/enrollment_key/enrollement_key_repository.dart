import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/service_provider.dart';

class EnrollmentKeyRepository {
  Stream<List<String>> loadServiceProvidersAsStream() {
    return FirebaseFirestore.instance
        .collection("staff_keys")
        .where("staff", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => e.data()['provider'].toString()).toList());
  }

  Future<ServiceProvider> loadProviderDetails(String email) async {
    return ServiceProvider.fromMap((await FirebaseFirestore.instance
            .collection("providers")
            .doc(email)
            .get())
        .data()!);
  }

  Future<List<ServiceProvider>> loadServiceProviders() async {
    List<String>? agencyIds = (await FirebaseFirestore.instance
            .collection("staff_keys")
            .where("staff", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get())
        .docs
        .map((e) => e.data()['provider'].toString())
        .toList();

    return agencyIds.isNotEmpty
        ? (await FirebaseFirestore.instance
                .collection("providers")
                .where("email", whereIn: agencyIds)
                .get())
            .docs
            .map(
              (e) => ServiceProvider.fromMap(
                Map<String, dynamic>.from(
                  e.data(),
                ),
              ),
            )
            .toList()
        : [];
  }

  Future<bool> isKeyExists(String key) async {
    return (await FirebaseFirestore.instance
                .collection("staff_keys")
                .where("key", isEqualTo: key)
                .where(
                  "staff",
                  isNull: true,
                )
                .get())
            .docs
            .isNotEmpty &&
        (await FirebaseFirestore.instance
                .collection("staffs")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("notifications")
                .where("key", isEqualTo: key)
                .get())
            .docs
            .isNotEmpty;
  }

  insertEnrollmentKey(String staffId, String enrollmentKey) async {
    await FirebaseFirestore.instance.collection("staffs").doc(staffId).update(
      {
        "enrollment_key": FieldValue.arrayUnion(
          [enrollmentKey],
        ),
      },
    );
  }

  removeEnrollmentKey(String staffId, String enrollmentKey) async {
    await FirebaseFirestore.instance.collection("staffs").doc(staffId).update(
      {
        "enrollment_key": FieldValue.arrayRemove(
          [enrollmentKey],
        ),
      },
    );
  }
}
