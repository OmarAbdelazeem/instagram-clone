part of 'following_bloc.dart';

@immutable
abstract class FollowingState {}

class FollowingInitial extends FollowingState {}

class FollowingChange extends FollowingState {
  final String id;

  FollowingChange(this.id);
}
