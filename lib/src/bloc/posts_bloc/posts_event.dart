part of 'posts_bloc.dart';

@immutable
abstract class TimeLineEvent {}

class FetchAllTimelinePostsStarted extends TimeLineEvent {
  final String userId;

  FetchAllTimelinePostsStarted(this.userId);
}

class FetchUserOwnPostsStarted extends TimeLineEvent {
  final String userId;

  FetchUserOwnPostsStarted(this.userId);
}

class PostDetailsLoadStarted extends TimeLineEvent {
  final String userId;
  final String postId;

  PostDetailsLoadStarted({required this.userId, required this.postId});
}

class PostUploadStarted extends TimeLineEvent {
  final XFile imageFile;
  final String caption;
  final UserModel user;

  PostUploadStarted(this.imageFile, this.caption, this.user);
}
