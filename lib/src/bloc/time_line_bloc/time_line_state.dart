part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineState {}

class TimeLineInitial extends TimeLineState {}

class FirstTimeLineLoading extends TimeLineState {}

class NextTimeLineLoading extends TimeLineState {}

class EmptyTimeline extends TimeLineState {}

class TimeLineLoaded extends TimeLineState {
  final List<PostModel> posts;

  TimeLineLoaded(this.posts);
}

class TimeLineChanged extends TimeLineState {}

class TimeLineError extends TimeLineState {
  final String error;

  TimeLineError(this.error);
}

class NewUploadedPostAdded extends TimeLineState {}
