import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/shift.dart';

class ShiftExpressState extends Equatable {
  final bool? isExpressSent;

  const ShiftExpressState({
    this.isExpressSent,
  });
  @override
  List<Object?> get props => [
        isExpressSent,
      ];
}

class ShiftExpressCubit extends Cubit<ShiftExpressState> {
  final Shift shift;

  ShiftExpressCubit(this.shift)
      : super(const ShiftExpressState(
          isExpressSent: true,
        )) {
    FirebaseFirestore.instance
        .collection("shifts")
        .doc(shift.id)
        .collection("interested_staffs")
        .where(
          "email",
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        )
        .snapshots()
        .listen((event) {
      emit(
        ShiftExpressState(
          isExpressSent: event.docs.isNotEmpty,
        ),
      );
    });
  }
}
