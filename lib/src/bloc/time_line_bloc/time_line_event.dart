part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineEvent {}

class FetchTimeLinePostsStarted extends TimeLineEvent {
}

class ListenToTimelinePostsStarted extends TimeLineEvent {}
