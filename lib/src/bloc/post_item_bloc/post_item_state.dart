part of 'post_item_bloc.dart';

@immutable
abstract class PostItemState {}

class PostItemInitial extends PostItemState {}

class PostIsLiked extends PostItemState {}

class AddingComment extends PostItemState {
  final String commentId;

  AddingComment(this.commentId);
}

class CommentAdded extends PostItemState {}

class PostIsUnLiked extends PostItemState {}

class CommentsLoading extends PostItemState {}

class CommentsLoaded extends PostItemState {
  final List<CommentModelResponse> comments;

  CommentsLoaded(this.comments);
}

class PostLoading extends PostItemState {}

class PostLoaded extends PostItemState {
  final PostModelResponse post;

  PostLoaded(this.post);
}
