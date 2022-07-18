part of 'logged_in_user_bloc.dart';

@immutable
abstract class LoggedInUserEvent {}

class SetLoggedInUserStarted extends LoggedInUserEvent {
  final UserModel user;

  SetLoggedInUserStarted(this.user);
}

class UpdateUserDataEventStarted extends LoggedInUserEvent {
  final UserData userData;
  final dynamic value;

  UpdateUserDataEventStarted({required this.userData, required this.value});
}

class FetchLoggedInUserDetailsStarted extends LoggedInUserEvent {}

class ListenToLoggedInUserStarted extends LoggedInUserEvent {}


class FetchLoggedInUserPostsStarted extends LoggedInUserEvent {
  final bool nextList;

  FetchLoggedInUserPostsStarted(this.nextList);
}

