part of 'follow_bloc.dart';

@immutable
abstract class FollowState {}

class FollowInitial extends FollowState {}

class UserFollowed extends FollowState {
  final UserModel? user;
  UserFollowed([this.user]);
}

class UserUnFollowed extends FollowState {
  final UserModel? user;
  UserUnFollowed([this.user]);
}


class Error extends FollowState{
  final String error;
  Error(this.error);
}
