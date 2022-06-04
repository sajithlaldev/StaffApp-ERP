import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/login/login_repository.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoginInitial extends LoginState {
  final bool? isVisiblePass;
  LoginInitial({
    this.isVisiblePass,
  });
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {}

class LoginChangeVisibilityLoading extends LoginState {}

class LoginSucess extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
  @override
  List<Object?> get props => [];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : super(
          LoginInitial(
            isVisiblePass: false,
          ),
        );

  changeVisible(bool visibility) {
    emit(LoginChangeVisibilityLoading());
    emit(
      LoginInitial(
        isVisiblePass: visibility,
      ),
    );
  }

  login(
    String email,
    String pass,
  ) async {
    emit(LoginLoading());
    try {
      //field validation
      if (email.isEmpty || pass.isEmpty || !EmailValidator.validate(email)) {
        if (email.isEmpty) throw Exception('e_email');
        if (!EmailValidator.validate(email)) {
          throw Exception('i_email');
        }
        if (pass.isEmpty) throw Exception('e_pass');
      }
      await LoginRepository.login(email, pass);

      //login success
      emit(LoginSucess());
    } catch (e) {
      //login failure
      emit(LoginFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  loginWithGoogle() async {
    emit(LoginLoading());
    try {
      await LoginRepository().signInWithGoogle();
      emit(LoginSucess());
    } catch (e) {
      print(e.toString());
      emit(LoginFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  loginWithApple() async {
    emit(LoginLoading());
    try {
      await LoginRepository().signInWithApple();
      emit(LoginSucess());
    } catch (e) {
      print(e.toString());
      emit(LoginFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
