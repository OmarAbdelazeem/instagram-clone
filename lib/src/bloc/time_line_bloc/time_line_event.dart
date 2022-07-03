part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineEvent {}

class FetchTimeLinePostsStarted extends TimeLineEvent {}

class ListenToTimelinePostsStarted extends TimeLineEvent {}

class AddNewUploadedPostStarted extends TimeLineEvent {
  final PostModelResponse post;

  AddNewUploadedPostStarted(this.post);
}
