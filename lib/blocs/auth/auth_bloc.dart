import 'dart:async';

import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AppUser?> _userSubscription;

  AuthBloc({@required AuthRepository? authRepository})
      : _authRepository = authRepository!,
        super(AuthState.unknown()) {
    _userSubscription = _authRepository.onAuthChanges.listen(
      (user) => add(AuthUserChanged(user: user)),
    );
    on<AuthUserChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthState.authenticated(user: event.user));
      } else {
        emit(AuthState.unAuthenticated());
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await _authRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
