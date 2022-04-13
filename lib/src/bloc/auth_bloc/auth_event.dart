part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginStarted extends AuthEvent {
  final String email;
  final String password;

  LoginStarted({required this.password, required this.email});
}

class SignUpWithEmailStarted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpWithEmailStarted(
      {required this.password, required this.email, required this.name});
}

class ProfilePhotoPicked extends AuthEvent {
  final XFile imageFile;

  ProfilePhotoPicked(this.imageFile);
}


