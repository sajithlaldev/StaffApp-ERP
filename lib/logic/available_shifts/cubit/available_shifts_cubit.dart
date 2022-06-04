import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/staff.dart';
import 'package:intl/intl.dart';
import '../../../data/models/shift.dart';
import '../../../data/repositories/available_shifts/available_shifts_repository.dart';

abstract class AvailableShiftsState extends Equatable {
  const AvailableShiftsState();

  @override
  List<Object> get props => [];
}

class AvailableShiftsInitial extends AvailableShiftsState {}

class AvailableShiftsLoading extends AvailableShiftsState {}

class AvailableShiftsLoaded extends AvailableShiftsState {
  final List<Shift> shifts;
  const AvailableShiftsLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class AvailableShiftsFailure extends AvailableShiftsState {
  final String message;
  const AvailableShiftsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AvailableShiftsCubit extends Cubit<AvailableShiftsState> {
  AvailableShiftsCubit() : super(AvailableShiftsInitial());

  loadShifts({
    int? sortIndex,
    bool? isDescending,
    String? providerId,
    required Staff staff,
    List<Map<String, String>>? filters,
  }) async {
    emit(AvailableShiftsLoading());
    try {
      List<String> orderBy = [
        "confirmation_number",
        "providerName",
        "staffName",
        "customerName",
        "from",
        "till"
      ];

  

      var provider_filter = {
        "name": "providerId",
        "value": providerId ??
            ("_" + FirebaseAuth.instance.currentUser!.email.toString()),
      };

      var till = {
        "name": "till",
        "value": "01-12-2300",
      };

      if (filters == null) {
        filters = [ provider_filter, till];
      } else {
        filters.add(provider_filter);
        filters.add(till);
      }

      LatLng currentLocation = LatLng(
        staff.l!.first,
        staff.l!.last,
      );

      //loading shifts from database
     List<Shift> shifts = await AvailableShiftsRepository().loadShifts(
          orderBy: sortIndex != null ? orderBy[sortIndex] : null,
          isDescending: isDescending,
          filters: filters,
          currentLocation: currentLocation,
        );
        emit(AvailableShiftsLoaded(shifts));
    } catch (e) {
      print(e.toString());
      emit(
        AvailableShiftsFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
