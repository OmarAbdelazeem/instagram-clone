part of 'searched_user_bloc.dart';

@immutable
abstract class SearchedUserEvent {}


class ListenToSearchedUserStarted extends SearchedUserEvent {}

class FollowUserEventStarted extends SearchedUserEvent {}

class UnFollowUserEventStarted extends SearchedUserEvent {}

class CheckIfUserIsFollowedStarted extends SearchedUserEvent {}

class FetchSearchedUserPostsStarted extends SearchedUserEvent {

}
