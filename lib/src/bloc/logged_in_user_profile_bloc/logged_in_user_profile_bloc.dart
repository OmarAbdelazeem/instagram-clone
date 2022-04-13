import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'logged_in_user_profile_event.dart';
part 'logged_in_user_profile_state.dart';

class LoggedInUserProfileBloc extends Bloc<LoggedInUserProfileEvent, LoggedInUserProfileState> {
  LoggedInUserProfileBloc() : super(LoggedInUserProfileInitial());

  @override
  Stream<LoggedInUserProfileState> mapEventToState(
    LoggedInUserProfileEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
