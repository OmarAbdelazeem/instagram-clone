part of 'searched_user_bloc.dart';

@immutable
abstract class SearchedUserState {}

class SearchedUserInitial extends SearchedUserState {}
class SearchedUserLoading extends SearchedUserState {}

class SearchedUserLoaded extends SearchedUserState {
  final UserModel user;

  SearchedUserLoaded(this.user);
}

class SearchedUserError extends SearchedUserState {
  final String error;

  SearchedUserError(this.error);
}

class SearchedUserIsFollowed extends SearchedUserState{}
class SearchedUserIsUnFollowed extends SearchedUserState{}
