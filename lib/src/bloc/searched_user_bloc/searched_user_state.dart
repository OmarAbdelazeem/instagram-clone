part of 'searched_user_bloc.dart';

@immutable
abstract class SearchedUserState {}

class SearchedUserInitial extends SearchedUserState {}

class SearchedUserLoading extends SearchedUserState {}

class SearchedUserLoaded extends SearchedUserState {
  final UserModel user;

  SearchedUserLoaded(this.user);
}

class SearchedUserPostsLoaded extends SearchedUserState {
  final List<PostModel> posts;

  SearchedUserPostsLoaded(this.posts);
}

class SearchedUserStateChanged extends SearchedUserState {
  final UserModel user;

  SearchedUserStateChanged(this.user);
}

class SearchedUserFirstPostsLoading extends SearchedUserState {}

class SearchedUserNextPostsLoading extends SearchedUserState {}

class SearchedUserError extends SearchedUserState {
  final String error;

  SearchedUserError(this.error);
}

class SearchedUserIsFollowed extends SearchedUserState {}

class SearchedUserIsUnFollowed extends SearchedUserState {}
