import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/notification.dart';

class NotificationAlertState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationAlertInitial extends NotificationAlertState {}

class NotificationAlertLoading extends NotificationAlertState {}

class NotificationNoAlert extends NotificationAlertState {}

class NotificationNewAlert extends NotificationAlertState {
  final List<NotificationModel> notificationModel;
  NotificationNewAlert({
    required this.notificationModel,
  });
  @override
  List<Object?> get props => [
        notificationModel,
      ];
}

class NotificationAlertFailure extends NotificationAlertState {
  final String error;
  NotificationAlertFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [
        error,
      ];
}

class NotificationAlertCubit extends Cubit<NotificationAlertState> {
  late StreamSubscription notificationAlertChanges;
  NotificationAlertCubit() : super(NotificationAlertInitial()) {
    notificationAlertChanges = FirebaseFirestore.instance
        .collection("staffs")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        List<NotificationModel> notifications =
            event.docs.map((e) => NotificationModel.fromMap(e.data())).toList();
        emit(
          NotificationNewAlert(notificationModel: notifications),
        );
      } else {
        emit(NotificationNoAlert());
      }
    });
  }
  markAsRead(List<NotificationModel> notifications) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    var ref = FirebaseFirestore.instance
        .collection("staffs")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("notifications");
    for (NotificationModel model in notifications) {
      batch.update(ref.doc(model.id), {"read": true});
    }
    batch.commit();
  }
}
