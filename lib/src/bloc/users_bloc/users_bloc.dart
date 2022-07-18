import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()){
    on<UpdateUserStarted>(_onUpdateUserStarted);
  }

  List<UserModel> users = [];


  FutureOr<void> _onUpdateUserStarted(
      UpdateUserStarted event, Emitter<UsersState> state) {
    int index = users.indexWhere((element) => element.id == event.user.id);
    if (index > -1) {
      users[index] = event.user;
      emit(UserAdded(event.user));
    } else {
      users.add(event.user);
    }
  }

  void addUser(UserModel user) {
    int index = users.indexWhere((element) => element.id == user.id);
    if (index > -1) {
      users[index] = user;
    } else {
      users.add(user);
    }
  }

  UserModel ? getUser(String userId) {
    return users.firstWhere((element) => element.id == userId);
  }
}
