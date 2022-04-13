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
    on<LoggedInUserDataSetted>(_onLoggedInUserDataSetted);
    on<ListenToUserDetailsStarted>(_onListenToUserDetailsStarted);
    // on<FetchRecommendedUsersStarted>(_onFetchRecommendedUsersStarted);
    // on<FollowEventStarted>(_onFollowStarted);
    // on<UnFollowEventStarted>(_onUnFollowStarted);
  }

  // UserModel? currentSearchedUserDetails;
  UserModel? loggedInUserDetails;
  UserModel? searchedUserDetails;
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

  _onLoggedInUserDataSetted(LoggedInUserDataSetted event, emit) {
    loggedInUserDetails = event.user;
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
      searchedUserDetails =
          UserModel.fromJson(jsonUserDetails.data() as Map<String, dynamic>);
      bool isFollowing = await _dataRepository.checkIfUserFollowingSomeOne(
          senderId: loggedInUserDetails!.id, receiverId: event.searchedUserId);
      emit(SearchedUserLoaded(searchedUserDetails!, isFollowing));
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  _onListenToUserDetailsStarted(ListenToUserDetailsStarted event, state) {
    try {
      _dataRepository.listenToUserDetails(event.userId).listen((streamEvent) {
        if (streamEvent.data() != null) {
          UserModel user =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          if (event.userId != loggedInUserDetails!.id)
            loggedInUserDetails = user;
          else
            searchedUserDetails = user;
          emit(UserDetailsLoaded(user));
        }
      });
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

// void _onFollowStarted(FollowEventStarted event,
//     Emitter<UsersState> state) async {
//   try {
//     await _dataRepository.addFollower(
//         receiverId: event.receiverId, senderId: event.senderId);
//   } catch (e) {
//     print(e.toString());
//     emit(UsersError(e.toString()));
//   }
// }
//
// void _onUnFollowStarted(UnFollowEventStarted event,
//     Emitter<UsersState> state) async {
//   try {
//     await _dataRepository.removeFollower(
//         receiverId: event.receiverId, senderId: event.senderId);
//   } catch (e) {
//     print(e.toString());
//     emit(UsersError(e.toString()));
//   }
// }

}
