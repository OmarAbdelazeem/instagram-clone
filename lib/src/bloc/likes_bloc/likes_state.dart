part of 'likes_bloc.dart';

@immutable
abstract class LikesState {}

class LikesInitial extends LikesState {}

class LikesChanged extends LikesState {
  final String postId;

  LikesChanged(this.postId);
}
