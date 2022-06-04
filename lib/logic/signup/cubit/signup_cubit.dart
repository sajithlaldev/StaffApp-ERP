import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/staff.dart';

import '../../../data/repositories/signup/signup_repository.dart';

class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupLoaded extends SignupState {
  final String? error;

  const SignupLoaded({this.error});

  @override
  List<Object> get props => [error ?? ""];
}

class SignupSuccess extends SignupState {
  final bool? isGoogleSignUp;
  const SignupSuccess({this.isGoogleSignUp});
  @override
  List<Object> get props => [isGoogleSignUp ?? ""];
}

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String cnfpass,
  }) async {
    emit(SignupLoading());
    try {
      if (name.isEmpty ||
          email.isEmpty ||
          !EmailValidator.validate(email) ||
          phone.isEmpty ||
          password.isEmpty ||
          cnfpass.isEmpty) {
        //validation section
        if (name.isEmpty) throw Exception("e_name");
        if (email.isEmpty) throw Exception("e_email");
        if (!EmailValidator.validate(email)) {
          throw Exception("i_email");
        }
        if (phone.isEmpty) throw Exception("e_phone");
        if (password.isEmpty) throw Exception("e_pass");
        if (cnfpass.isEmpty) throw Exception("e_cnfpass");
      } else {
        // validating password
        if (password != cnfpass) {
          throw Exception("no_match");
        }
        var credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: cnfpass,
        );

        if (credentials.user != null && !credentials.user!.emailVerified) {
          await credentials.user!.sendEmailVerification();
        }

        await SignupRepository().registerStaff(
          name: name,
          email: email,
          phone: phone,
        );

        emit(const SignupSuccess());
      }
    } catch (e) {
      emit(
        SignupLoaded(error: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }

  Future signUpWithGoogle({
    required String name,
    required String phone,
  }) async {
    emit(SignupLoading());
    try {
      await SignupRepository().signUpWithGoogle(
        name: name,
        phone: phone,
      );

      emit(
        const SignupSuccess(
          isGoogleSignUp: true,
        ),
      );
    } catch (e) {
      emit(
        SignupLoaded(error: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }

  Future signUpWithApple({
    required String phone,
    required String name,
  }) async {
    emit(SignupLoading());
    try {
      await SignupRepository().signUpWithApple(
        name: name,
        phone: phone,
      );

      emit(
        const SignupSuccess(
          isGoogleSignUp: true,
        ),
      );
    } catch (e) {
      emit(
        SignupLoaded(error: e.toString().replaceAll("Exception: ", "")),
      );
    }
  }
}
