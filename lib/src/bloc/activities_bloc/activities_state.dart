part of 'activities_bloc.dart';

@immutable
abstract class ActivitiesState {}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesError extends ActivitiesState {
  final String error;

  ActivitiesError(this.error);
}

class ActivitiesLoaded extends ActivitiesState {
  final List<NotificationResponseModel> activities;

  ActivitiesLoaded(this.activities);
}
