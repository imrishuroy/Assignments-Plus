import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository? _authRepository;

  LoginCubit({@required AuthRepository? authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void loginWithPhone() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository!.signInWithPhone(state.phoneNumber!);
      emit(state.copyWith(status: LoginStatus.succuss));
    } catch (error) {}
  }

  void phoneNumberChanged(String value) async {
    emit(state.copyWith(phoneNumber: value, status: LoginStatus.initial));
  }

  void otp(String value) async {
    emit(state.copyWith(otp: value, status: LoginStatus.initial));
  }

  void logInWithGoogle() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository!.signInWithGoogle();
      emit(state.copyWith(status: LoginStatus.succuss));
    } on Failure catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.error,
          failure: Failure(message: error.message),
        ),
      );
    }
  }
}
