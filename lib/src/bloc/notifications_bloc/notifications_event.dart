part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsEvent {}

class ListenToTokenStarted extends NotificationsEvent{}

class ListenToForGroundMessageStarted extends NotificationsEvent{}

class ListenToForMessageOpeningAppStarted extends NotificationsEvent{}
