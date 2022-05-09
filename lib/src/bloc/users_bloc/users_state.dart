part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;

  UsersLoaded(this.users);
}

class LoggedInUserLoaded extends UsersState {
  final UserModel user;

  LoggedInUserLoaded(this.user);
}

class SearchedUserLoaded extends UsersState {
  final UserModel searchedUser;

  SearchedUserLoaded(this.searchedUser);
}

class UsersError extends UsersState {
  final String error;

  UsersError(this.error);
}
