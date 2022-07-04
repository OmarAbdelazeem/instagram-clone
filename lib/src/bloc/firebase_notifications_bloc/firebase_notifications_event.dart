part of 'firebase_notifications_bloc.dart';

@immutable
abstract class FirebaseNotificationsEvent {}

class ListenToTokenStarted extends FirebaseNotificationsEvent{}

class ListenToForGroundMessageStarted extends FirebaseNotificationsEvent{}

class ListenToForMessageOpeningAppStarted extends FirebaseNotificationsEvent{}
