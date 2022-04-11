part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class LoginButtonPressed extends UsersEvent {}

class SearchByTermEventStarted extends UsersEvent{
  final String term;
  SearchByTermEventStarted({required this.term});
}

class SearchByIdEventStarted extends UsersEvent{
  final String searchedUserId;
  final String loggedInUserId;
  SearchByIdEventStarted({required this.searchedUserId , required this.loggedInUserId});
}

class FetchRecommendedUsersStarted extends UsersEvent{
  final String userId;
  FetchRecommendedUsersStarted(this.userId);
}

class FollowEventStarted extends UsersEvent {
  final String senderId;
  final String receiverId;

  FollowEventStarted({required this.receiverId, required this.senderId
  });
}

class UnFollowEventStarted extends UsersEvent {
  final String senderId;
  final String receiverId;

  UnFollowEventStarted({required this.receiverId, required this.senderId
  });
}
