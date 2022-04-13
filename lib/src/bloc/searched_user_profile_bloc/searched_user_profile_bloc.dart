import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'searched_user_profile_event.dart';
part 'searched_user_profile_state.dart';

class SearchedUserProfileBloc extends Bloc<SearchedUserProfileEvent, SearchedUserProfileState> {
  SearchedUserProfileBloc() : super(SearchedUserProfileInitial());

  @override
  Stream<SearchedUserProfileState> mapEventToState(
    SearchedUserProfileEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
