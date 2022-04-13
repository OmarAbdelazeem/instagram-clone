import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final DataRepository _dataRepository;

  UsersBloc(this._dataRepository) : super(UsersInitial()) {
    on<SearchByTermEventStarted>(_onSearchByTermStarted);
    on<SearchByIdEventStarted>(_onSearchByIdStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    on<SetSearchedUserStarted>(_onSetSearchedUserStarted);
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    // on<FollowEventStarted>(_onFollowStarted);
    // on<UnFollowEventStarted>(_onUnFollowStarted);
    // on<FetchRecommendedUsersStarted>(_onFetchRecommendedUsersStarted);
  }

  UserModel? loggedInUser;
  UserModel? searchedUser;
  List<UserModel> fetchedUsers = [];

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

  _onSetLoggedInUserStarted(SetLoggedInUserStarted event, emit) {
    loggedInUser = event.user;
  }

  _onSetSearchedUserStarted(SetSearchedUserStarted event, emit) {
    searchedUser = event.user;
  }

  // _onFetchRecommendedUsersStarted(FetchRecommendedUsersStarted event,
  //     Emitter<UsersState> state) async {
  //   try {
  //
  //   } catch (e) {
  //
  //   }
  // }

  _onSearchByIdStarted(SearchByIdEventStarted event, emit) async {
    try {
      emit(UsersLoading());
      final jsonUserDetails =
          await _dataRepository.getUserDetails(event.searchedUserId);
      searchedUser =
          UserModel.fromJson(jsonUserDetails.data() as Map<String, dynamic>);
      bool isFollowing = await _dataRepository.checkIfUserFollowingSearched(
          senderId: loggedInUser!.id, receiverId: event.searchedUserId);
      emit(SearchedUserLoaded(searchedUser!, isFollowing));
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  _onListenToLoggedInUserStarted(ListenToLoggedInUserStarted event, state) {
    try {
      _dataRepository
          .listenToUserDetails(loggedInUser!.id)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          loggedInUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          emit(UserDetailsLoaded(loggedInUser!));
        }
      });
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  _onListenToSearchedUserStarted(ListenToSearchedUserStarted event, state) {
    try {
      _dataRepository
          .listenToUserDetails(searchedUser!.id)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          searchedUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          emit(UserDetailsLoaded(searchedUser!));
        }
      });
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  // void _onFollowStarted(
  //     FollowEventStarted event, Emitter<UsersState> state) async {
  //   try {
  //     await _dataRepository.addFollower(
  //         receiverId: searchedUser!.id, senderId: loggedInUser!.id);
  //   } catch (e) {
  //     print(e.toString());
  //     emit(UsersError(e.toString()));
  //   }
  // }

  // void _onUnFollowStarted(
  //     UnFollowEventStarted event, Emitter<UsersState> state) async {
  //   try {
  //     await _dataRepository.removeFollower(
  //         receiverId: searchedUser!.id, senderId: loggedInUser!.id);
  //   } catch (e) {
  //     print(e.toString());
  //     emit(UsersError(e.toString()));
  //   }
  // }
}
