part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventStarted extends AuthEvent {
  final String email;
  final String password;

  AuthEventStarted({required this.password, required this.email});
}


