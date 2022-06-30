part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class LoggingOut extends AuthState{}

class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess(this.user);
}

class UserLoggedOut extends AuthState{}


class Error extends AuthState {
  final String error;

  Error(this.error);
}

class ProfilePhotoUploaded extends AuthState {
  final String imageUrl;

  ProfilePhotoUploaded(this.imageUrl);
}
