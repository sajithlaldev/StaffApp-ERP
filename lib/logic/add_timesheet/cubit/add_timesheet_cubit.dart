import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/view_timesheets/signatures.dart';

import '../../../data/models/view_timesheets/timesheet.dart';
import '../../../data/repositories/timesheets/timesheets_repository.dart';

class AddTimeSheetState extends Equatable {
  const AddTimeSheetState();

  @override
  List<Object> get props => [];
}

class AddTimeSheetInitial extends AddTimeSheetState {}

class AddTimeSheetLoading extends AddTimeSheetState {}

class AddTimeSheetSuccess extends AddTimeSheetState {}

class AddTimeSheetFailure extends AddTimeSheetState {
  final String error;
  const AddTimeSheetFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AddTimeSheetCubit extends Cubit<AddTimeSheetState> {
  AddTimeSheetCubit() : super(AddTimeSheetInitial());

  addTimesheet({
    required TimeSheet timeSheet,
    required bool isAdd,
    required Signatures signatures,
  }) async {
    emit(AddTimeSheetLoading());
    try {
      if (timeSheet.isEmpty()) {
        throw Exception("Fill all fields");
      }
      await TimeSheetsRepository().addTimesheet(
        timeSheet,
        isAdd: isAdd,
        signatures: signatures,
      );
      emit(AddTimeSheetSuccess());
    } catch (e) {
      emit(
        AddTimeSheetFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
