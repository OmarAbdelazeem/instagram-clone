part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class TokenUpdated extends NotificationsState {}

class TokenError extends NotificationsState {
  final String error;

  TokenError(this.error);
}
