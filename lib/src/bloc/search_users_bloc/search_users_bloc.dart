import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagramapp/src/core/utils/initialize_user.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';
import '../users_bloc/users_bloc.dart';

part 'search_users_event.dart';

part 'search_users_state.dart';

class UsersSearchBloc extends Bloc<UsersEvent, SearchUsersState> {
  final DataRepository _dataRepository;
  final UsersBloc _usersBloc;

  UsersSearchBloc(this._dataRepository, this._usersBloc)
      : super(SearchUsersInitial()) {
    on<SearchByTermEventStarted>(_onSearchByTermStarted);
    on<FetchRecommendedUsersStarted>(_onFetchRecommendedUsersStarted);
  }

  List<UserModel> recommendedUsers = [];
  QueryDocumentSnapshot? lastSearchDocument;
  String? lastTerm;
  bool isSearchReachedToTheEnd = false;

  _onSearchByTermStarted(SearchByTermEventStarted event, emit) async {
    List<UserModel> searchedUsers = [];
    if (event.term.isNotEmpty) {
      try {
        emit(SearchedUsersLoading());
        var searchedUserStream =
            _dataRepository.searchForUser(term: event.term);
        await for (var docs in searchedUserStream) {
          for (var doc in docs) {
            UserModel user = await initializeUser(doc.data(), _dataRepository);
            searchedUsers.add(user);
            _usersBloc.addUser(user);
          }

          int loggedInUserIndex = searchedUsers.indexWhere((element) {
            return element.id == _dataRepository.loggedInUserId;
          });
          if (loggedInUserIndex != -1) {
            searchedUsers.removeAt(loggedInUserIndex);
          }
          emit(SearchedUsersLoaded(searchedUsers));
        }
      } catch (e) {
        print(e.toString());
        emit(SearchedUsersError(e.toString()));
      }
    } else {
      emit(SearchedUsersLoaded([]));
    }
  }

  _onFetchRecommendedUsersStarted(FetchRecommendedUsersStarted event,
      Emitter<SearchUsersState> state) async {
    try {
      final recommendedUsersDocs = await _dataRepository.getRecommendedUsers();
      for (var doc in recommendedUsersDocs) {
        UserModel user = await initializeUser(
            doc.data() as Map<String, dynamic>, _dataRepository);
        recommendedUsers.add(user);
        _usersBloc.addUser(user);
      }

      emit(RecommendedUsersLoaded());
    } catch (e) {
      print(e.toString());
      emit(RecommendedUsersError(e.toString()));
    }
  }
}
