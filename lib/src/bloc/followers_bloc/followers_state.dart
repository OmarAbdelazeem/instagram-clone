part of 'followers_bloc.dart';

@immutable
abstract class FollowersState extends Equatable {}

class FollowersInitial extends FollowersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FollowersFirstLoading extends FollowersState {
  @override
// TODO: implement props
  List<Object?> get props => [];
}

class FollowersNextLoading extends FollowersState {
  @override
// TODO: implement props
  List<Object?> get props => [];
}

class FollowersLoaded extends FollowersState {
  final List<UserModel> users;

  FollowersLoaded(this.users);

  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class FollowersError extends FollowersState {
  final String error;

  FollowersError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
