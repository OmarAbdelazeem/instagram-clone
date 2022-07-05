part of 'likes_bloc.dart';

@immutable
abstract class LikesEvent {}

class AddPostLikesInfoStarted extends LikesEvent {
  final int likes;
  final String id;
  final bool isLiked;

  AddPostLikesInfoStarted(
      {required this.isLiked, required this.likes, required this.id});
}

class EditPostCaptionStarted extends LikesEvent {
  final String caption;
  final String id;

  EditPostCaptionStarted({required this.caption, required this.id});
}

class ListenToLikeChangesStarted extends LikesEvent {
  final String id;

  ListenToLikeChangesStarted(this.id);
}
