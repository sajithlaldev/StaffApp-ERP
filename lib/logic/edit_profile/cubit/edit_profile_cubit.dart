import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/signup/signup_repository.dart';

class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileFailure extends EditProfileState {
  final String? error;

  const EditProfileFailure({this.error});

  @override
  List<Object> get props => [error ?? ""];
}

class EditProfileSuccess extends EditProfileState {}

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future EditProfile({
    required String name,
    required String phone,
  }) async {
    emit(EditProfileLoading());
    try {
      if (name.isEmpty || phone.isEmpty || phone.length != 10) {
        //validation section
        if (name.isEmpty) throw Exception("Name cannot be empty");

        if (phone.isEmpty) throw Exception("Phone cannot be empty");
        if (phone.length != 10) throw Exception("Invalid phone number");
      } else {
        // validating password

        await SignupRepository().updateStaff({
          "name": name,
          "phone": phone,
        });

        emit(EditProfileSuccess());
      }
    } catch (e) {
      emit(
        EditProfileFailure(error: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
