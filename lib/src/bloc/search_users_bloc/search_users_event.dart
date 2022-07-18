part of 'search_users_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable {}

class SearchByTermEventStarted extends UsersEvent {
  final String term;
  final bool nextList;

  SearchByTermEventStarted({required this.term, required this.nextList});

  @override
  // TODO: implement props
  List<Object?> get props => [term, nextList];
}

class FetchRecommendedUsersStarted extends UsersEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
