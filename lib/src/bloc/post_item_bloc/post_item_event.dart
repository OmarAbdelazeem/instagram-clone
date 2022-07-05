part of 'post_item_bloc.dart';

@immutable
abstract class PostItemEvent {}

class AddLikeStarted extends PostItemEvent {
  final String postId;
  final String userId;

  AddLikeStarted({required this.postId, required this.userId});
}

class RemoveLikeStarted extends PostItemEvent {
  final String postId;
  final String userId;

  RemoveLikeStarted({required this.userId, required this.postId});
}

class LoadCommentsStarted extends PostItemEvent {
  final String postId;

  LoadCommentsStarted(this.postId);
}

class AddCommentStarted extends PostItemEvent {
  final CommentModelResponse comment;

  AddCommentStarted({required this.comment});
}

class CheckIfPostStateIsChangedStarted extends PostItemEvent {}

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
  PostEditStarted({required this.value ,required this.postId});
}
