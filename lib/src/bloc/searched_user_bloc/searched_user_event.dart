part of 'searched_user_bloc.dart';

@immutable
abstract class SearchedUserEvent {}

class SetSearchedUserIdStarted extends SearchedUserEvent {
  final String searchedUserId;

  SetSearchedUserIdStarted(this.searchedUserId);
}

class ListenToSearchedUserStarted extends SearchedUserEvent {}

class FollowUserEventStarted extends SearchedUserEvent {
  final String loggedInUserId;

  FollowUserEventStarted(this.loggedInUserId);
}

class UnFollowUserEventStarted extends SearchedUserEvent {
  final String loggedInUserId;

  UnFollowUserEventStarted(this.loggedInUserId);
}

class CheckIfUserIsFollowedStarted extends SearchedUserEvent {
  final String loggedInUserId;

  CheckIfUserIsFollowedStarted({required this.loggedInUserId});
}
