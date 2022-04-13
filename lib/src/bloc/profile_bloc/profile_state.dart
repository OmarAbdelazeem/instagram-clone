part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileDataLoaded extends ProfileState {
  final UserModel user;
  ProfileDataLoaded(this.user);
}
