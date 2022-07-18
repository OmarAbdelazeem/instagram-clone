part of 'post_item_bloc.dart';

@immutable
abstract class PostItemState {}

class PostItemInitial extends PostItemState {}

class AddingComment extends PostItemState {
  final String commentId;

  AddingComment(this.commentId);
}

class CommentAdded extends PostItemState {}

class FirstCommentsLoading extends PostItemState {}

class NextCommentsLoading extends PostItemState {}

class CommentsLoaded extends PostItemState {
  final List<CommentModel> comments;

  CommentsLoaded(this.comments);
}

class PostStateChanged extends PostItemState {}

class CommentsError extends PostItemState {
  final String error;

  CommentsError(this.error);
}

class PostLoading extends PostItemState {}

class PostItemError extends PostItemState {
  final String error;

  PostItemError(this.error);
}

class PostLoaded extends PostItemState {
  final PostModel post;

  PostLoaded(this.post);
}

class EditingPostCaption extends PostItemState {}

class PostCaptionEdited extends PostItemState {
  final String caption;

  PostCaptionEdited(this.caption);
}

class EditPostCaptionError extends PostItemState {
  final String error;

  EditPostCaptionError(this.error);
}
