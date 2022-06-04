import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/shift.dart';

import '../../../data/models/staff.dart';
import '../../../data/repositories/available_shifts/available_shifts_repository.dart';

class AcceptJobState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AcceptJobLoading extends AcceptJobState {}

class AcceptJobSendLoading extends AcceptJobState {}

class AcceptJobSuccess extends AcceptJobState {}

class AcceptJobFailure extends AcceptJobState {
  final String error;
  AcceptJobFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [
        error,
      ];
}

class AcceptJobCubit extends Cubit<AcceptJobState> {
  AcceptJobCubit() : super(AcceptJobLoading()) {}

  AcceptJobPressed({
    Staff? staff,
    required String shiftId,
    String? cNo,
  }) async {
    emit(AcceptJobSendLoading());
    try {
      if (staff == null) {
        throw Exception("No Staff Selected!");
      } else {
        await AvailableShiftsRepository().assignStaff(
          shiftId,
          staff,
          cNo: cNo,
        );
        emit(AcceptJobSuccess());
      }
    } catch (e) {
      emit(
        AcceptJobFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  expressInterestPressed({
    Staff? staff,
    required String shiftId,
  }) async {
    emit(AcceptJobSendLoading());
    try {
      if (staff == null) {
        throw Exception("No Staff Selected!");
      } else {
        await AvailableShiftsRepository().expressInterest(
          shiftId,
          staff,
        );
        emit(AcceptJobSuccess());
      }
    } catch (e) {
      emit(
        AcceptJobFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }

  cancelJobPressed({
    Staff? staff,
    required Shift shift,
    String? cNo,
  }) async {
    emit(AcceptJobSendLoading());
    try {
      if (staff == null) {
        throw Exception("No Staff Selected!");
      } else {
        await AvailableShiftsRepository().cancelShift(
          shift,
          staff,
        );
        emit(AcceptJobSuccess());
      }
    } catch (e) {
      emit(
        AcceptJobFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
