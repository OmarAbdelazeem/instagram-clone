part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class Loading extends PostsState {}

class PostLoaded extends PostsState {
  final PostModel post;

  PostLoaded(this.post);
}

class PostsLoaded extends PostsState {
  final List<PostModel> posts;

  PostsLoaded(this.posts);
}

class PostUploaded extends PostsState{}

class Error extends PostsState {
  final String error;

  Error(this.error);
}
