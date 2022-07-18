part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostAdded extends PostsState {
  final PostModel post;

  PostAdded(this.post);
}

