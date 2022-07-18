part of 'following_bloc.dart';

@immutable
abstract class FollowingState extends Equatable{}

class FollowingInitial extends FollowingState {
  @override
// TODO: implement props
  List<Object?> get props => [];
}



class FollowingFirstLoading extends FollowingState {  @override
// TODO: implement props
List<Object?> get props => [];}

class FollowingNextLoading extends FollowingState {  @override
// TODO: implement props
List<Object?> get props => [];}

class FollowingLoaded extends FollowingState {
  final List<UserModel> users;

  FollowingLoaded(this.users);
  @override
// TODO: implement props
  List<Object?> get props => [users];
}

class FollowingError extends FollowingState {
  final String error;

  FollowingError(this.error);
  @override
// TODO: implement props
  List<Object?> get props => [error];
}
