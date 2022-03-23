part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineState {}

class TimeLineInitial extends TimeLineState {}

class TimeLineLoading extends TimeLineState {}

class TimeLineLoaded extends TimeLineState {
  final List<PostWidget> posts;

  TimeLineLoaded(this.posts);
}

class TimeLineError extends TimeLineState {
 final String error;

 TimeLineError(this.error);
}