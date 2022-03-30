part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Loading extends AuthState {}

class AuthSuccess extends AuthState {}

class UserCreated extends AuthState {}

class Error extends AuthState {
  final String error;

  Error(this.error);
}

class ProfilePhotoAdded extends AuthState {
  final String imageUrl;

  ProfilePhotoAdded(this.imageUrl);
}
