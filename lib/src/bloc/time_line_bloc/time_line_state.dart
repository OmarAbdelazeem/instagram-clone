part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineState {}

class TimeLineInitial extends TimeLineState {}

class TimeLineLoading extends TimeLineState {}

class PostLoaded extends TimeLineState{
  final PostModel post;

  PostLoaded(this.post);
}

class TimeLineLoaded extends TimeLineState {
  final List<PostModel> posts;

  TimeLineLoaded(this.posts);
}

class TimeLineError extends TimeLineState {
  final String error;

  TimeLineError(this.error);
}
