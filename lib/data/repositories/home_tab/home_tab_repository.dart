import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/shift.dart';
import 'package:intl/intl.dart';

class HomeTabRepository {
  Stream<List<Shift>> fetchShifts() {
    return FirebaseFirestore.instance
        .collection("shifts")
        .where(
          "staffId",
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        )
        .where("status", isEqualTo: "confirmed")
        .where(
          "from",
          isGreaterThanOrEqualTo:
              DateFormat("yyyy-MM-dd").format(DateTime.now()) + " 00:00",
        )
        .where(
          "from",
          isLessThanOrEqualTo:
              DateFormat("yyyy-MM-dd").format(DateTime.now()) + " 23:59",
        )
        .orderBy(
          "from",
          descending: true,
        )
        .snapshots()
        .map((event) => event.docChanges
            .map((e) => Shift.fromMap(Map<String, dynamic>.from(e.doc.data()!)))
            .toList());
  }
}
