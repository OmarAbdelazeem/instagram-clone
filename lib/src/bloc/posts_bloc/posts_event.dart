part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class UpdatePostStarted extends PostsEvent {
  final PostModel post;

  UpdatePostStarted(this.post);
}


