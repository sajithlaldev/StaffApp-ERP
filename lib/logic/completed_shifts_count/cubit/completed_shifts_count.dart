import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedShiftsCountState extends Equatable {
  final int count;
  const CompletedShiftsCountState(this.count);
  @override
  List<Object?> get props => [count];
}

class CompletedShiftsCountCubit extends Cubit<CompletedShiftsCountState> {
  late StreamSubscription streamSubscription;
  CompletedShiftsCountCubit() : super(const CompletedShiftsCountState(0)) {
    streamSubscription = FirebaseFirestore.instance
        .collection("shifts")
        .where(
          "staff.email",
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        )
        .where(
          "status",
          isEqualTo: 'completed',
        )
        .snapshots()
        .listen((event) {
      emit(CompletedShiftsCountState(event.size));
    });
  }
}
