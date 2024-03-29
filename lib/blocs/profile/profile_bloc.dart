import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/models/app_user_model.dart';
import '/repositories/auth/auth_repository.dart';
import '/repositories/profile/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  StreamSubscription? _streamSubscription;
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;
  late StreamSubscription? _authSubsciption;

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

    on<LoadProfile>((event, emit) async {
      await _streamSubscription?.cancel();
      _streamSubscription = _profileRepository
          .streamUser(userId)
          .listen((appUser) => add(ProfileUpdated(appUser)));
    });
    // print

    on<UpdateProfile>((event, emit) async {
      await _profileRepository.updateProfile(event.appUser, userId!);
    });

    on<ProfileUpdated>((event, emit) async {
      emit(ProfileLoaded(event.appUser!));
    });
  }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _authSubsciption?.cancel();

    return super.close();
  }
}
