part of 'following_bloc.dart';

@immutable
abstract class FollowingEvent {}

class AddFollowerIdStarted extends FollowingEvent {
  final String id;

  AddFollowerIdStarted(this.id);
}

class RemoveFollowerIdStarted extends FollowingEvent {
  final String id;

  RemoveFollowerIdStarted(this.id);
}
