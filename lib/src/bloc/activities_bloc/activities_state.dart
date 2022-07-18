part of 'activities_bloc.dart';

@immutable
abstract class ActivitiesState extends Equatable{}

class ActivitiesInitial extends ActivitiesState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FirstActivitiesLoading extends ActivitiesState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NextActivitiesLoading extends ActivitiesState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ActivitiesError extends ActivitiesState {
  final String error;

  ActivitiesError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class ActivitiesLoaded extends ActivitiesState {
  final List<NotificationModel> activities;

  ActivitiesLoaded(this.activities);
  // TODO: implement props
  List<Object?> get props => [activities];
}
