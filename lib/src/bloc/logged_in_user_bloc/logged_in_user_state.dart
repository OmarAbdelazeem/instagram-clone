part of 'logged_in_user_bloc.dart';

@immutable
abstract class LoggedInUserState {}

class LoggedInUserInitial extends LoggedInUserState {}

class LoggedInUserLoaded extends LoggedInUserState {}

class LoggedInUserDetailsLoading extends LoggedInUserState {}

class LoggedInUserDetailsLoaded extends LoggedInUserState {}

class LoggedInUserEmptyPosts extends LoggedInUserState {}

class LoggedInUserError extends LoggedInUserState {
  final String error;

  LoggedInUserError(this.error);
}

class LoggedInUserPostsLoading extends LoggedInUserState {}

class LoggedInUserPostsLoaded extends LoggedInUserState {
  final List<PostModelResponse> posts;

  LoggedInUserPostsLoaded(this.posts);
}

class UpdatingUserData extends LoggedInUserState {}

class UpdatedUserData extends LoggedInUserState {}

class UpdateUserDataError extends LoggedInUserState {
  final String error;

  UpdateUserDataError(this.error);
}
