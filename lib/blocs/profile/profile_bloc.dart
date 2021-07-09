import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/profile/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  StreamSubscription? _streamSubscription;
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
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
    await _streamSubscription?.cancel();
    _streamSubscription = _profileRepository
        .streamUser()
        .listen((appUser) => add(ProfileUpdated(appUser)));
  }

  Stream<ProfileState> _mapEditTodoToState(UpdateProfile event) async* {
    _profileRepository.updateProfile(event.appUser);
  }

  Stream<ProfileState> _mapProfileUpdatedToState(ProfileUpdated event) async* {
    yield ProfileLoaded(event.appUser!);
  }
}
