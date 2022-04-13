part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;

  UsersLoaded(this.users);
}

class UserDetailsLoaded extends UsersState {
  final UserModel user;

  UserDetailsLoaded(this.user);
}

class SearchedUserLoaded extends UsersState {
  final UserModel user;
  final bool isFollowing;

  SearchedUserLoaded(this.user, this.isFollowing);
}

class UsersError extends UsersState {
  final String error;

  UsersError(this.error);
}
