part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class SearchByTermEventStarted extends UsersEvent {
  final String term;

  SearchByTermEventStarted({required this.term});
}

class SearchByIdEventStarted extends UsersEvent {
  final String searchedUserId;

  SearchByIdEventStarted({required this.searchedUserId});
}

class FetchRecommendedUsersStarted extends UsersEvent {
  final String userId;

  FetchRecommendedUsersStarted(this.userId);
}

class SetLoggedInUserStarted extends UsersEvent {
  final UserModel user;

  SetLoggedInUserStarted(this.user);
}

class SetSearchedUserStarted extends UsersEvent {
  final UserModel user;

  SetSearchedUserStarted(this.user);
}

class ListenToLoggedInUserStarted extends UsersEvent {}

class ListenToSearchedUserStarted extends UsersEvent {}
