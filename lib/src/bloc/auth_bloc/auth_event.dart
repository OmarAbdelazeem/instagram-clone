part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginButtonTapped extends AuthEvent {
  final String email;
  final String password;

  LoginButtonTapped({required this.password, required this.email});
}

class SignUpButtonTapped extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpButtonTapped(
      {required this.password, required this.email, required this.name});
}

class PickProfilePhotoTapped extends AuthEvent {
  final ImageSource imageSource;

  PickProfilePhotoTapped(this.imageSource);
}
