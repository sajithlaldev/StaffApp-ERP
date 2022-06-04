import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/service_provider.dart';
import '../../../data/models/staff.dart';

class ProviderDetailsState extends Equatable {
  final bool? isExpressSent;
  final int? jobsCount;

  const ProviderDetailsState({this.isExpressSent, this.jobsCount});
  @override
  List<Object?> get props => [isExpressSent, jobsCount];
}

class ProviderDetailsCubit extends Cubit<ProviderDetailsState> {
  final Staff staff;
  final ServiceProvider provider;

  ProviderDetailsCubit(this.staff, this.provider)
      : super(const ProviderDetailsState(
          isExpressSent: false,
          jobsCount: 0,
        )) {
    FirebaseFirestore.instance
        .collection("providers")
        .doc(provider.email)
        .collection("interested_staffs")
        .where("email", isEqualTo: staff.email)
        .snapshots()
        .listen((event) {
      emit(
        ProviderDetailsState(
          isExpressSent: event.docs.isNotEmpty,
          jobsCount: state.jobsCount,
        ),
      );
    });
    FirebaseFirestore.instance
        .collection("shifts")
        .where("providerId", isEqualTo: provider.email)
        .where("status", isEqualTo: "pooled")
        .snapshots()
        .listen((event) {
      emit(
        ProviderDetailsState(
          isExpressSent: state.isExpressSent,
          jobsCount: event.docs.length,
        ),
      );
    });
  }
}
