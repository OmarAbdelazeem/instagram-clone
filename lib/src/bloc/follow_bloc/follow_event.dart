part of 'follow_bloc.dart';

@immutable
abstract class FollowEvent {}

class FollowEventStarted extends FollowEvent {
  final String senderId;
  final UserModel receiverUser;

  FollowEventStarted({required this.receiverUser, required this.senderId
  });
}

class UnFollowEventStarted extends FollowEvent {
  final String senderId;
  final UserModel receiverUser;

  UnFollowEventStarted({required this.receiverUser, required this.senderId
  });
}

class CheckUserFollowingStateStarted extends FollowEvent{
  final String receiverId;
  final String senderId;
  CheckUserFollowingStateStarted({required this.receiverId,required this.senderId});
}

