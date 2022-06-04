import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiftapp/data/models/view_timesheets/timesheet.dart';
import '../../../data/models/staff.dart';
import '../../../data/repositories/timesheets/timesheets_repository.dart';

abstract class TimesheetsState extends Equatable {
  const TimesheetsState();

  @override
  List<Object> get props => [];
}

class TimesheetsInitial extends TimesheetsState {}

class TimesheetsLoading extends TimesheetsState {}

class TimesheetsLoaded extends TimesheetsState {
  final List<TimeSheet> timesheets;
  const TimesheetsLoaded(this.timesheets);

  @override
  List<Object> get props => [timesheets];
}

class TimesheetsFailure extends TimesheetsState {
  final String message;
  const TimesheetsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class TimesheetsCubit extends Cubit<TimesheetsState> {
  TimesheetsCubit() : super(TimesheetsInitial()) {
    loadTimesheets();
  }

  loadTimesheets({
    int? sortIndex,
    bool? isDescending,
    List<Map<String, String>>? filters,
  }) async {
    emit(TimesheetsLoading());
    try {
      var staff_filter = {
        "name": "staffId",
        "value": FirebaseAuth.instance.currentUser!.email.toString(),
      };

      if (filters == null) {
        filters = [staff_filter];
      } else {
        filters.add(staff_filter);
      }

      //loading shifts from database
      List<TimeSheet> timehseets = await TimeSheetsRepository().loadTimeSheets(
        filters: filters,
      );
      emit(TimesheetsLoaded(timehseets));
    } catch (e) {
      print(e.toString());
      emit(
        TimesheetsFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
