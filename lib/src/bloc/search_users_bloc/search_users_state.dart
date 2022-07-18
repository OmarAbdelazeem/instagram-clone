part of 'search_users_bloc.dart';

@immutable
abstract class SearchUsersState extends Equatable {}

class SearchUsersInitial extends SearchUsersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchedUsersLoading extends SearchUsersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchedUsersNextLoading extends SearchUsersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RecommendedUsersLoaded extends SearchUsersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// class FollowersLoaded extends UsersState {}
//
// class FollowingLoaded extends UsersState {}

class SearchedUsersLoaded extends SearchUsersState {
  final List<UserModel> users;

  SearchedUsersLoaded(this.users);

  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class EmptyUsers extends SearchUsersState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchedUsersError extends SearchUsersState {
  final String error;

  SearchedUsersError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class RecommendedUsersError extends SearchUsersState {
  final String error;

  RecommendedUsersError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
