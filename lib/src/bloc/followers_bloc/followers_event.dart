part of 'followers_bloc.dart';

@immutable
abstract class FollowersEvent extends Equatable {}

class FetchFollowersStarted extends FollowersEvent {
  final bool nextList;

  FetchFollowersStarted(this.nextList);

  @override
// TODO: implement props
  List<Object?> get props => [];
}
