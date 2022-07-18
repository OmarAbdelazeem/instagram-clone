part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class LoginStarted extends AuthEvent {
  final String email;
  final String password;

  LoginStarted({required this.password, required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class AutoLoginStarted extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LogoutStarted extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignUpWithEmailStarted extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpWithEmailStarted(
      {required this.password, required this.email, required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [name, email, password];
}

class ProfilePhotoPicked extends AuthEvent {
  final XFile imageFile;

  ProfilePhotoPicked(this.imageFile);
  @override
  // TODO: implement props
  List<Object?> get props => [imageFile];
}
