part of 'activities_bloc.dart';

@immutable
abstract class ActivitiesEvent extends Equatable{}

class FetchActivitiesStarted extends ActivitiesEvent {
  final bool nextList;

  FetchActivitiesStarted(this.nextList);
  // TODO: implement props
  List<Object?> get props => [nextList];
}
