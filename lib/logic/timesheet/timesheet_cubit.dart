import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/data/models/shift.dart';
import 'package:hiftapp/data/models/view_timesheets/timesheet.dart';
import 'package:hiftapp/data/repositories/timesheets/timesheets_repository.dart';
import '../../data/repositories/overview/overview_repository.dart';

import '../../data/models/notification.dart';

class TimesheetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimesheetInitial extends TimesheetState {}

class TimesheetLoading extends TimesheetState {}

class TimesheetLoaded extends TimesheetState {
  final TimeSheet? timesheet;

  TimesheetLoaded({
    required this.timesheet,
  });
  @override
  List<Object?> get props => [timesheet];
}

class TimesheetFailure extends TimesheetState {
  final String error;
  TimesheetFailure({
    required this.error,
  });
  @override
  List<Object?> get props => [
        error,
      ];
}

class TimesheetCubit extends Cubit<TimesheetState> {
  final String shiftId;
  TimesheetCubit({required this.shiftId}) : super(TimesheetInitial()) {
    init(shiftId);
  }

  init(String shiftId) async {
    emit(TimesheetLoading());
    try {
      TimeSheet? timeSheet =
          await TimeSheetsRepository().loadTimesheet(shiftId);

      emit(
        TimesheetLoaded(
          timesheet: timeSheet,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(
        TimesheetFailure(
          error: e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
