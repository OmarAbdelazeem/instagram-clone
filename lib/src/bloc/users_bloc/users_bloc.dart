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
    // on<LoginButtonPressed>(_loginButtonPressed);
    on<SearchByTermEventStarted>(_onSearchByTermStarted);
    on<SearchByIdEventStarted>(_onSearchByIdStarted);
    on<FetchRecommendedUsersStarted>(_onFetchRecommendedUsersStarted);
    on<FollowEventStarted>(_onFollowStarted);
    on<UnFollowEventStarted>(_onUnFollowStarted);
  }

  UserModel? loggedInUserDetails;
  UserModel? searchedUserDetails;
  List<UserModel> fetchedUsers = [];

  // _loginButtonPressed(LoginButtonPressed event, emit) {
  //   try {
  //     var jsonUserDetails =
  //         _dataRepository.getUserDetails(_authRepository.loggedInUser!.uid);
  //     // loggedInUserDetails = UserModel.fromJson(jsonUserDetails);
  //   } catch (e) {}
  // }

  _onSearchByTermStarted(SearchByTermEventStarted event, emit) async {
    if (event.term.isNotEmpty) {
      emit(UsersLoading());
      try {
        _dataRepository.searchForUser(event.term).listen((event) {
          final users = event.docs
              .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
              .toList();
          fetchedUsers = users;
        });
        emit(UsersLoaded(fetchedUsers));
      } catch (e) {
        print(e.toString());
        emit(UsersError(e.toString()));
      }
    } else {
      emit(UsersInitial());
    }
  }

  _onFetchRecommendedUsersStarted(FetchRecommendedUsersStarted event,
      Emitter<UsersState> state) async {
    try {

    } catch (e) {

    }
  }

  _onSearchByIdStarted(SearchByIdEventStarted event, emit) async {
    print("userId is ${event.searchedUserId}");
    try {
      emit(UsersLoading());
      final jsonUserDetails = await _dataRepository.getUserDetails(
          event.searchedUserId);
      var user =
      UserModel.fromJson(jsonUserDetails.data() as Map<String, dynamic>);
      bool isFollowing = await _dataRepository.checkIfUserFollowingSomeOne(
          senderId: event.loggedInUserId, receiverId: event.searchedUserId);
      emit(UserLoaded(user, isFollowing));
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  void _onFollowStarted(FollowEventStarted event,
      Emitter<UsersState> state) async {
    try {
      await _dataRepository.addFollower(
          receiverId: event.receiverId, senderId: event.senderId);
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  void _onUnFollowStarted(UnFollowEventStarted event,
      Emitter<UsersState> state) async {
    try {
      await _dataRepository.removeFollower(
          receiverId: event.receiverId, senderId: event.senderId);
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

}
