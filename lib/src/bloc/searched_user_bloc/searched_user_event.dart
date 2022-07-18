part of 'searched_user_bloc.dart';

@immutable
abstract class SearchedUserEvent {}

class ListenToSearchedUserStarted extends SearchedUserEvent {}

class FollowUserEventStarted extends SearchedUserEvent {
  final UserModel user;

  FollowUserEventStarted(this.user);
}

class UnFollowUserEventStarted extends SearchedUserEvent {
  final UserModel user;

  UnFollowUserEventStarted(this.user);
}


class FetchSearchedUserPostsStarted extends SearchedUserEvent {
  final nextList;

  FetchSearchedUserPostsStarted(this.nextList);
}

class ListenToFollowUpdatesStarted extends SearchedUserEvent {}
