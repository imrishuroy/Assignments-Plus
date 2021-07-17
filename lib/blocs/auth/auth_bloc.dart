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
  }

  @override
  Future<void> close() {
    print('-------------------- Bloc CLoses it self');
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield* _mapUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.signOut();
      // yield* _mapUserLogoutToState(event);
    }
  }

  Stream<AuthState> _mapUserChangedToState(AuthUserChanged event) async* {
    print('Auth Bloc User -----------------${event.user?.uid}');
    yield event.user != null
        ? AuthState.authenticated(user: event.user)
        : AuthState.unAuthenticated();
  }

  // Stream<AuthState> _mapUserLogoutToState(AuthLogoutRequested event) async* {
  //   _authRepository.signOut();
  //   yield AuthState.unAuthenticated();
  // }
}
