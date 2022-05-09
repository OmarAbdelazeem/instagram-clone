import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';

import '../../models/user_model/user_model.dart';

part 'logged_in_user_event.dart';

part 'logged_in_user_state.dart';

class LoggedInUserBloc extends Bloc<LoggedInUserEvent, LoggedInUserState> {
  final DataRepository _dataRepository;

  LoggedInUserBloc(this._dataRepository) : super(LoggedInUserInitial()) {
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
  }

  UserModel? loggedInUser;

  _onListenToLoggedInUserStarted(ListenToLoggedInUserStarted event, state) {
    try {
      _dataRepository
          .listenToUserDetails(loggedInUser!.id!)
          .listen((streamEvent) {
        print("streamEvent.data() is ${streamEvent.data()}");
        if (streamEvent.data() != null) {
          loggedInUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          emit(LoggedInUserLoaded());
        }
      });
    } catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  _onSetLoggedInUserStarted(SetLoggedInUserStarted event, emit) {
    loggedInUser = event.user;
  }
}
