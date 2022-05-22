part of 'logged_in_user_bloc.dart';

@immutable
abstract class LoggedInUserState {}

class LoggedInUserInitial extends LoggedInUserState {}

class LoggedInUserLoaded extends LoggedInUserState {}

class LoggedInUserError extends LoggedInUserState {
  final String error;

  LoggedInUserError(this.error);
}

class LoggedInUserPostsLoading extends LoggedInUserState {}

class LoggedInUserPostsLoaded extends LoggedInUserState {
  final List<PostModel> posts;

  LoggedInUserPostsLoaded(this.posts);
}
