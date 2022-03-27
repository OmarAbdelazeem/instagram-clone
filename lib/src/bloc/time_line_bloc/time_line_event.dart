part of 'time_line_bloc.dart';

@immutable
abstract class TimeLineEvent {}

class TimeLineLoadStarted extends TimeLineEvent {}

class FetchPostDetailsStarted extends TimeLineEvent {
  final String userId;
  final String postId;

  FetchPostDetailsStarted({required this.userId, required this.postId});
}
