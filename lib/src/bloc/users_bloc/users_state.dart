part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}
class UserAdded extends UsersState {
  final UserModel user;

  UserAdded(this.user);
}