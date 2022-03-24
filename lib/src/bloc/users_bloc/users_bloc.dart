import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  UsersBloc(this._dataRepository, this._authRepository)
      : super(UsersInitial()) {
    on<LoginButtonPressed>(_loginButtonPressed);
    on<SearchByTermEventTriggered>(_searchByTermTriggered);
    on<SearchByIdEventTriggered>(_searchByIdTriggered);
  }

  UserModel? loggedInUserDetails;
  UserModel? searchedUserDetails;

  _loginButtonPressed(LoginButtonPressed event, emit) {
    try {
      var jsonUserDetails =
          _dataRepository.getUserDetails(_authRepository.loggedInUser!.uid);
      // loggedInUserDetails = UserModel.fromJson(jsonUserDetails);
    } catch (e) {}
  }

  _searchByTermTriggered(SearchByTermEventTriggered event, emit) {
    try {
      emit(UsersLoading());
      _dataRepository.searchForUser(event.term);
      // loggedInUserDetails = UserModel.fromJson(jsonUserDetails);
    } catch (e) {}
  }

  _searchByIdTriggered(SearchByIdEventTriggered event, emit) {
    try {
      emit(UsersLoading());
      var jsonUserDetails =
          _dataRepository.getUserDetails(_authRepository.loggedInUser!.uid);
      // loggedInUserDetails = UserModel.fromJson(jsonUserDetails);
    } catch (e) {}
  }
}
