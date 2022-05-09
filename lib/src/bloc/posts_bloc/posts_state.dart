part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class TimeLinePostsLoading extends PostsState {}

class SearchedUserPostsLoading extends PostsState {}

class LoggedInUserPostsLoading extends PostsState {}

class TimeLinePostsLoaded extends PostsState {
  final List<PostModel> posts;

  TimeLinePostsLoaded(this.posts);
}

class SearchedUserPostsLoaded extends PostsState {
  final List<PostModel> posts;

  SearchedUserPostsLoaded(this.posts);
}

class LoggedInUserPostsLoaded extends PostsState {
  final List<PostModel> posts;

  LoggedInUserPostsLoaded(this.posts);
}

class UpLoadingPost extends PostsState {}

class PostLoaded extends PostsState {
  final PostModel post;

  PostLoaded(this.post);
}

// class PostsLoaded extends PostsState {
//   final List<PostModel> posts;
//
//   PostsLoaded(this.posts);
// }

class PostUploaded extends PostsState {}

class Error extends PostsState {
  final String error;

  Error(this.error);
}
