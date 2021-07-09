part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final AppUser appUser;

  ProfileLoaded(this.appUser);

  @override
  List<Object> get props => [appUser];

  @override
  bool? get stringify => true;
}
