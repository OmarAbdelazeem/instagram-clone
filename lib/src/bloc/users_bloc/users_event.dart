part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}
class UpdateUserStarted extends UsersEvent {
  final UserModel user;

  UpdateUserStarted(this.user);
}