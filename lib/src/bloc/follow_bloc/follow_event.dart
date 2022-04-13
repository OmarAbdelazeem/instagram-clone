part of 'follow_bloc.dart';

@immutable
abstract class FollowEvent {}

class FollowEventStarted extends FollowEvent {}

class UnFollowEventStarted extends FollowEvent {}

class CheckUserFollowingStarted extends FollowEvent {
  final UserModel loggedInUser;
  final UserModel searchedUser;

  CheckUserFollowingStarted(
      {required this.loggedInUser, required this.searchedUser});
}
