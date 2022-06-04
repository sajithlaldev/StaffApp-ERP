import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/staff.dart';
import '../../../data/repositories/my_shifts/my_shifts_repository.dart';
import '../../../data/models/shift.dart';

abstract class MyShiftsState extends Equatable {
  const MyShiftsState();

  @override
  List<Object> get props => [];
}

class MyShiftsInitial extends MyShiftsState {}

class MyShiftsLoading extends MyShiftsState {}

class MyShiftsLoaded extends MyShiftsState {
  final List<Shift> shifts;
  const MyShiftsLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class MyShiftsFailure extends MyShiftsState {
  final String message;
  const MyShiftsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class MyShiftsCubit extends Cubit<MyShiftsState> {
  MyShiftsCubit({
    required Staff staff,
  }) : super(MyShiftsInitial()) {
    loadShifts(
      staff: staff,
    );
  }

  loadShifts({
    String? date,
    required Staff staff,
  }) async {
    emit(MyShiftsLoading());
    try {
      LatLng currentLocation = LatLng(
        staff.l!.first,
        staff.l!.last,
      );

      //loading shifts from database
      List<Shift> shifts = await MyShiftsRepository().loadShifts(
        date: date,
        currentLocation: currentLocation,
      );
      emit(MyShiftsLoaded(shifts));
    } catch (e) {
      emit(
        MyShiftsFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
