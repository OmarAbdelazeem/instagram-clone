part of 'logged_in_user_bloc.dart';

@immutable
abstract class LoggedInUserEvent {}

class SetLoggedInUserStarted extends LoggedInUserEvent {
  final UserModel user;

  SetLoggedInUserStarted(this.user);
}

class FetchLoggedInUserDetailsStarted extends LoggedInUserEvent{

}

class ListenToLoggedInUserStarted extends LoggedInUserEvent {}

class FetchLoggedInUserPostsStarted extends LoggedInUserEvent{}
