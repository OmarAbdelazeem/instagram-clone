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

class LoggedInUserDataSetted extends UsersEvent {
  final UserModel user;

  LoggedInUserDataSetted(this.user);
}

class ListenToUserDetailsStarted extends UsersEvent {
  final String userId;

  ListenToUserDetailsStarted(this.userId);
}
