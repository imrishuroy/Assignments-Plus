import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

import 'package:flutter_todo/repositories/profile/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late StreamSubscription _streamSubscription;
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;
  late StreamSubscription _authSubsciption;

  String? userId;
  ProfileBloc({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        super(ProfileInitial()) {
    _authSubsciption = _authRepository.onAuthChanges.listen((AppUser? user) {
      if (user?.uid != null) {
        userId = user?.uid;
        _streamSubscription =
            profileRepository.streamUser(userId).listen((event) {
          add(LoadProfile());
        });
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _authSubsciption.cancel();

    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield* _mapLoadProfileToState();
    } else if (event is UpdateProfile) {
      yield* _mapEditTodoToState(event);
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedToState(event);
    }
  }

  Stream<ProfileState> _mapLoadProfileToState() async* {
    await _streamSubscription.cancel();
    _streamSubscription = _profileRepository
        .streamUser(userId)
        .listen((appUser) => add(ProfileUpdated(appUser)));
  }

  Stream<ProfileState> _mapEditTodoToState(UpdateProfile event) async* {
    _profileRepository.updateProfile(event.appUser, userId!);
  }

  Stream<ProfileState> _mapProfileUpdatedToState(ProfileUpdated event) async* {
    yield ProfileLoaded(event.appUser!);
  }
}
