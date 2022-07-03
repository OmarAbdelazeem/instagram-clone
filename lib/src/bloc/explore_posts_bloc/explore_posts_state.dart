part of 'explore_posts_bloc.dart';

@immutable
abstract class ExplorePostsState {}

class ExplorePostsInitial extends ExplorePostsState {}

class ExplorePostsLoading extends ExplorePostsState {}

class ExplorePostsEmpty extends ExplorePostsState {}

class ExplorePostsLoaded extends ExplorePostsState {
  final List<PostModelResponse> posts;

  ExplorePostsLoaded(this.posts);
}

class ExplorePostsError extends ExplorePostsState {
  final String error;

  ExplorePostsError(this.error);
}
