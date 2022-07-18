part of 'following_bloc.dart';

@immutable
abstract class FollowingEvent extends Equatable {}

class FetchFollowingUsersStarted extends FollowingEvent {
  final bool nextList;

  FetchFollowingUsersStarted(this.nextList);

  @override
// TODO: implement props
  List<Object?> get props => [nextList];
}
