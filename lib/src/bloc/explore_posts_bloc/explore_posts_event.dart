part of 'explore_posts_bloc.dart';

@immutable
abstract class ExplorePostsEvent extends Equatable{}

class FetchExplorePostsStarted extends ExplorePostsEvent {
  final bool nextList;

  FetchExplorePostsStarted(this.nextList);
  @override
  // TODO: implement props
  List<Object?> get props => [nextList];
}
