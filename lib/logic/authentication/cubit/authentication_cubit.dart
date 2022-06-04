import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/staff.dart';
import '../../../data/repositories/login/login_repository.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final Staff? staff;
  const AuthenticationSuccess(this.staff);
  @override
  List<Object> get props => [staff ?? ""];
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late StreamSubscription authSubscription;
  AuthenticationCubit() : super(AuthenticationInitial());

  checkAuthentication() async {
    emit(AuthenticationInitial());

    if (await FirebaseAuth.instance.authStateChanges().first != null) {
      emit(
        AuthenticationSuccess(
          await LoginRepository().fetchStaff(),
        ),
      );
    } else {
      emit(AuthenticationFailure());
    }
  }

  // auth logout
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    emit(AuthenticationFailure());
  }
}
