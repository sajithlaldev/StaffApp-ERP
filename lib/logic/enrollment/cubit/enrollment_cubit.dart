import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/service_provider.dart';

import '../../../data/models/staff.dart';
import '../../../data/repositories/enrollment_key/enrollement_key_repository.dart';

class EnrollmentKeyState extends Equatable {
  const EnrollmentKeyState();

  @override
  List<Object> get props => [];
}

class EnrollmentKeyInitial extends EnrollmentKeyState {}

class EnrollmentKeyLoading extends EnrollmentKeyState {}

class EnrollmentKeyLoaded extends EnrollmentKeyState {
  final List<Future<ServiceProvider>> providers;

  const EnrollmentKeyLoaded({
    required this.providers,
  });

  @override
  List<Object> get props => [
        providers,
      ];
}

class EnrollmentKeySuccess extends EnrollmentKeyState {}

class EnrollmentKeyFailure extends EnrollmentKeyState {
  final String error;
  const EnrollmentKeyFailure(this.error);

  @override
  List<Object> get props => [error];
}

class EnrollmentKeyCubit extends Cubit<EnrollmentKeyState> {
  final Staff staff;
  EnrollmentKeyCubit(this.staff) : super(EnrollmentKeyInitial()) {
    loadEnrollmentKey(staff);
  }

  loadEnrollmentKey(Staff staff) async {
    EnrollmentKeyRepository().loadServiceProvidersAsStream().listen(
      (event) {
        emit(
          EnrollmentKeyLoaded(
              providers: event
                  .map((e) async =>
                      await EnrollmentKeyRepository().loadProviderDetails(e))
                  .toList()),
        );
      },
    );
  }

  Future insertEnrollmentKey({
    required String enrollment_key,
  }) async {
    emit(EnrollmentKeyLoading());
    try {
      if (enrollment_key.isNotEmpty &&
          await EnrollmentKeyRepository().isKeyExists(enrollment_key)) {
        await EnrollmentKeyRepository()
            .insertEnrollmentKey(staff.email, enrollment_key);
      } else {
        throw Exception("Invalid Key");
      }
      emit(EnrollmentKeySuccess());
    } catch (e) {
      emit(
        EnrollmentKeyFailure(
          e.toString().replaceAll("Exception: ", ""),
        ),
      );
    }
  }
}
