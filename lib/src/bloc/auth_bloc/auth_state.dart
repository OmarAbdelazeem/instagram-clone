part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable{}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoggingOut extends AuthState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess(this.user);
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UserLoggedOut extends AuthState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class Error extends AuthState {
  final String error;

  Error(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ProfilePhotoUploaded extends AuthState {
  final String imageUrl;

  ProfilePhotoUploaded(this.imageUrl);
  @override
  // TODO: implement props
  List<Object?> get props => [imageUrl];
}
