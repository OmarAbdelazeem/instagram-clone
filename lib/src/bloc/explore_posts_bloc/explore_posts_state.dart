part of 'explore_posts_bloc.dart';

@immutable
abstract class ExplorePostsState extends Equatable{}

class ExplorePostsInitial extends ExplorePostsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FirstExplorePostsLoading extends ExplorePostsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class NextExplorePostsLoading extends ExplorePostsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ExplorePostsLoaded extends ExplorePostsState {
  final List<PostModel> posts;

  ExplorePostsLoaded(this.posts);
  @override
  // TODO: implement props
  List<Object?> get props => [posts];
}

class ExplorePostsError extends ExplorePostsState {
  final String error;

  ExplorePostsError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
