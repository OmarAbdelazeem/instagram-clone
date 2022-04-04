part of 'posts_bloc.dart';

@immutable
abstract class TimeLineEvent {}

class FetchAllTimelinePostsStarted extends TimeLineEvent {}

class PostDetailsLoadStarted extends TimeLineEvent {
  final String userId;
  final String postId;

  PostDetailsLoadStarted({required this.userId, required this.postId});
}

class PostUploadStarted extends TimeLineEvent{
  final PostModel post;
  PostUploadStarted(this.post);
}
