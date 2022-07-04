part of 'firebase_notifications_bloc.dart';

@immutable
abstract class FirebaseNotificationsState {}

class NotificationsInitial extends FirebaseNotificationsState {}

class TokenUpdated extends FirebaseNotificationsState {}

class TokenError extends FirebaseNotificationsState {
  final String error;

  TokenError(this.error);
}

