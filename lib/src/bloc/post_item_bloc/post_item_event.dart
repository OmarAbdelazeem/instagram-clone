part of 'post_item_bloc.dart';

@immutable
abstract class PostItemEvent {}

class AddLikeStarted extends PostItemEvent {
  final String postId;

  AddLikeStarted({required this.postId});
}

class RemoveLikeStarted extends PostItemEvent {
  final String postId;

  RemoveLikeStarted({required this.postId});
}

class FetchCommentsStarted extends PostItemEvent {
  final String postId;
  final bool nextList;

  FetchCommentsStarted(this.postId, this.nextList);
}

class AddCommentStarted extends PostItemEvent {
  final CommentModel comment;

  AddCommentStarted({required this.comment});
}

class ListenForPostUpdatesStarted extends PostItemEvent {}

class CheckIfPostIsEditedStarted extends PostItemEvent {}

class ListenToPostStarted extends PostItemEvent {
  final String postId;

  ListenToPostStarted({required this.postId});
}

class FetchPostDetailsStarted extends PostItemEvent {
  final String postId;

  FetchPostDetailsStarted(this.postId);
}

class PostEditStarted extends PostItemEvent {
  final String value;
  final String postId;

  PostEditStarted({required this.value, required this.postId});
}
