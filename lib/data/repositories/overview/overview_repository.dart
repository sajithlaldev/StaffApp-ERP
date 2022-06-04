import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/notification.dart';

class NotificationRepository {
  Future<List<NotificationModel>> loadNotifications() async {
    final res = (await FirebaseFirestore.instance
            .collection("staffs")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("notifications")
            .orderBy(
              "created_on",
              descending: true,
            )
            .get())
        .docs
        .map((e) => NotificationModel.fromMap(e.data()))
        .toList();
    return res;
  }
}
