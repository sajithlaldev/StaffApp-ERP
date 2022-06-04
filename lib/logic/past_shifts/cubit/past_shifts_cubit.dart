import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/shift.dart';
import '../../../data/models/staff.dart';
import '../../../data/repositories/available_shifts/available_shifts_repository.dart';
import '../../../data/repositories/past_shifts/past_shifts_repository.dart';

abstract class PastShiftsState extends Equatable {
  const PastShiftsState();

  @override
  List<Object> get props => [];
}

class PastShiftsInitial extends PastShiftsState {}

class PastShiftsLoading extends PastShiftsState {}

class PastShiftsLoaded extends PastShiftsState {
  final List<Shift> shifts;
  const PastShiftsLoaded(this.shifts);

  @override
  List<Object> get props => [shifts];
}

class PastShiftsFailure extends PastShiftsState {
  final String message;
  const PastShiftsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PastShiftsCubit extends Cubit<PastShiftsState> {
  final Staff staff;
  PastShiftsCubit({required this.staff}) : super(PastShiftsInitial()) {
    loadShifts(
      status: 'completed',
    );
  }

  loadShifts({
    int? sortIndex,
    bool? isDescending,
    String? providerId,
    required String status,
    List<Map<String, String>>? filters,
  }) async {
    emit(PastShiftsLoading());
    try {
      List<String> orderBy = [
        "confirmation_number",
        "providerName",
        "staffName",
        "customerName",
        "from",
        "till"
      ];

      var status_filter = {
        "name": "status",
        "value": status,
      };

      var provider_filter = {
        "name": "staffId",
        "value": FirebaseAuth.instance.currentUser!.email.toString(),
      };

      if (filters == null) {
        filters = [status_filter, provider_filter];
      } else {
        filters.add(status_filter);
        filters.add(provider_filter);
      }

      LatLng currentLocation = LatLng(
        staff.l!.first,
        staff.l!.last,
      );

      //loading shifts from database
      List<Shift> shifts = await PastShiftsRepository().loadShifts(
        orderBy: sortIndex != null ? orderBy[sortIndex] : null,
        isDescending: isDescending,
        filters: filters,
        currentLocation: currentLocation,
      );
      emit(PastShiftsLoaded(shifts));
    } catch (e) {
      print(e.toString());
      emit(
        PastShiftsFailure(e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
