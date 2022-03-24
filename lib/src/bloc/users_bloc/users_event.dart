part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class LoginButtonPressed extends UsersEvent {}

class SearchByTermEventTriggered extends UsersEvent{
  final String term;
  SearchByTermEventTriggered({required this.term});
}

class SearchByIdEventTriggered extends UsersEvent{
  final String id;
  SearchByIdEventTriggered({required this.id});
}
