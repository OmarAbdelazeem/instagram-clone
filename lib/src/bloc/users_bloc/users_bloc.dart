import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';

part 'users_event.dart';

part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final DataRepository _dataRepository;
  final String _loggedInUserId;

  UsersBloc(this._dataRepository, this._loggedInUserId)
      : super(UsersInitial()) {
    on<SearchByTermEventStarted>(_onSearchByTermStarted);
    // on<SearchByIdEventStarted>(_onSearchByIdStarted);
    // on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    // on<SetSearchedUserStarted>(_onSetSearchedUserStarted);
    // on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    // on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    on<FetchRecommendedUsersStarted>(_onFetchRecommendedUsersStarted);
    on<FetchFollowingStarted>(_onFetchFollowingStarted);
    on<FetchFollowersStarted>(_onFetchFollowersStarted);
  }

  List<UserModel> recommendedUsers = [];
  List<UserModel> followingUsers = [];
  List<UserModel> followersUsers = [];

  _onSearchByTermStarted(SearchByTermEventStarted event, emit) async {
    if (event.term.isNotEmpty) {
      emit(UsersLoading());
      try {
        var fetchedUsersData = await _dataRepository.searchForUser(event.term);
        List<UserModel> fetchedUsers =
            List.generate(fetchedUsersData.docs.length, (index) {
          var currentUserData = fetchedUsersData.docs[index];
          return UserModel.fromJson(
              currentUserData.data() as Map<String, dynamic>);
        });

        int loggedInUserIndex = fetchedUsers.indexWhere((element) {
          return element.id == AuthRepository().getCurrentUser()!.uid;
        });
        if (loggedInUserIndex != -1) {
          fetchedUsers.removeAt(loggedInUserIndex);
        }
        emit(UsersLoaded(fetchedUsers));
      } catch (e) {
        print(e.toString());
        emit(UsersError(e.toString()));
      }
    } else {
      emit(UsersInitial());
    }
  }

  _onFetchRecommendedUsersStarted(
      FetchRecommendedUsersStarted event, Emitter<UsersState> state) async {
    try {
      final recommendedUsersData = await _dataRepository.getRecommendedUsers();
      if (recommendedUsersData.isNotEmpty) {
        recommendedUsers = List<UserModel>.generate(
            recommendedUsersData.length,
            (index) => UserModel.fromJson(
                recommendedUsersData[index].data() as Map<String, dynamic>));
        emit(RecommendedUsersLoaded());
      } else {
        emit(EmptyUsers());
      }
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  _onFetchFollowersStarted(
      FetchFollowersStarted event, Emitter<UsersState> state) async {
    try {
      final followersData = await _dataRepository.getFollowers();
      if (followersData.isNotEmpty) {
        followersUsers = List<UserModel>.generate(
            followersData.length,
            (index) => UserModel.fromJson(
                followersData[index].data() as Map<String, dynamic>));
        emit(RecommendedUsersLoaded());
      } else {
        emit(EmptyUsers());
      }
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

  _onFetchFollowingStarted(
      FetchFollowingStarted event, Emitter<UsersState> state) async {
    try {
      emit(FollowingLoading());
      final followingData = await _dataRepository.getFollowing();
      if (followingData.isNotEmpty) {
        followingUsers = List<UserModel>.generate(
            followingData.length,
            (index) => UserModel.fromJson(
                followingData[index].data() as Map<String, dynamic>));
        emit(FollowingLoaded());
      } else {
        emit(EmptyUsers());
      }
    } catch (e) {
      print(e.toString());
      emit(UsersError(e.toString()));
    }
  }

// _onSearchByIdStarted(SearchByIdEventStarted event, emit) async {
//   try {
//     emit(UsersLoading());
//     final jsonUserDetails =
//         await _dataRepository.getUserDetails(event.searchedUserId);
//     bool isFollowing = await _dataRepository.checkIfUserFollowingSearched(
//         senderId: loggedInUser!.id, receiverId: event.searchedUserId);
//     searchedUser = SearchedUser(
//         UserModel.fromJson(jsonUserDetails.data() as Map<String, dynamic>),
//         isFollowing);
//
//     emit(SearchedUserLoaded(searchedUser!));
//   } catch (e) {
//     print(e.toString());
//     emit(UsersError(e.toString()));
//   }
// }

// _onListenToLoggedInUserStarted(ListenToLoggedInUserStarted event, state) {
//   try {
//     _dataRepository
//         .listenToUserDetails(loggedInUser!.id!)
//         .listen((streamEvent) {
//       if (streamEvent.data() != null) {
//         loggedInUser =
//             UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
//         emit(LoggedInUserLoaded(loggedInUser!));
//       }
//     });
//   } catch (e) {
//     emit(UsersError(e.toString()));
//   }
// }

// _onListenToSearchedUserStarted(ListenToSearchedUserStarted event, state) {
//   try {
//     _dataRepository
//         .listenToUserDetails(searchedUser!.id!)
//         .listen((streamEvent) {
//       if (streamEvent.data() != null) {
//         searchedUser =
//             UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
//         emit(SearchedUserLoaded(searchedUser!));
//       }
//     });
//   } catch (e) {
//     emit(UsersError(e.toString()));
//   }
// }
}
