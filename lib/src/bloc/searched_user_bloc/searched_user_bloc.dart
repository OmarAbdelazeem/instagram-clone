import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/posts_repository.dart';
import 'package:meta/meta.dart';
import '../../core/utils/initialize_post.dart';
import '../../models/post_model/post_model.dart';
import '../../repository/data_repository.dart';
import '../posts_bloc/posts_bloc.dart';

part 'searched_user_event.dart';

part 'searched_user_state.dart';

class SearchedUserBloc extends Bloc<SearchedUserEvent, SearchedUserState> {
  final DataRepository _dataRepository;
  final String _searchedUserId;
  final PostsBloc _postsBloc;
  final UsersBloc _usersBloc;

  SearchedUserBloc(this._dataRepository, this._postsBloc, this._searchedUserId,
      this._usersBloc)
      : super(SearchedUserInitial()) {
    on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    on<FollowUserEventStarted>(_onFollowStarted);
    on<UnFollowUserEventStarted>(_onUnFollowStarted);
    on<ListenToFollowUpdatesStarted>(_onListenToFollowUpdatesStarted);
    on<FetchSearchedUserPostsStarted>(_onFetchSearchedUserPostsStarted);
  }

  List<PostModel> _posts = [];
  UserModel? _searchedUser;

  // bool? _isFollowed;
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

  _onListenToSearchedUserStarted(
      ListenToSearchedUserStarted event, Emitter<SearchedUserState> state) {
    try {
      _dataRepository
          .listenToUserDetails(_searchedUserId)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          _searchedUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          if (!isClosed) emit(SearchedUserLoaded(_searchedUser!));
        }
      });
    } catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onFetchSearchedUserPostsStarted(FetchSearchedUserPostsStarted event,
      Emitter<SearchedUserState> emit) async {
    try {
      List<QueryDocumentSnapshot> postsDocs = [];

      if (!event.nextList) {
        emit(SearchedUserFirstPostsLoading());
        _posts = [];
        isReachedToTheEnd = false;
        postsDocs =
            (await _dataRepository.getUserPosts(userId: _searchedUserId)).docs;
      } else {
        emit(SearchedUserNextPostsLoading());
        postsDocs = (await _dataRepository.getUserPosts(
                documentSnapshot: lastDocument, userId: _searchedUserId))
            .docs;
      }

      for (var doc in postsDocs) {
        PostModel postResponse = await initializePost(
            doc.data() as Map<String, dynamic>, _dataRepository);
        _postsBloc.addPost(postResponse);
        _posts.add(postResponse);
      }

      if (postsDocs.isNotEmpty) {
        lastDocument = postsDocs.last;
      } else if (postsDocs.isEmpty && _posts.isNotEmpty) {
        isReachedToTheEnd = true;
      }

      emit(SearchedUserPostsLoaded(_posts));
    } on Exception catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onFollowStarted(
      FollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsFollowed());
      _usersBloc.add(UpdateUserStarted(event.user));
      await _dataRepository.addFollowing(receiverId: _searchedUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsUnFollowed());
      _usersBloc.add(UpdateUserStarted(event.user));
      await _dataRepository.removeFollowing(receiverId: _searchedUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  _onListenToFollowUpdatesStarted(
      ListenToFollowUpdatesStarted event, Emitter<SearchedUserState> state) {
    UserModel? user = _usersBloc.getUser(_searchedUserId);
    if (user != null) {
      emit(SearchedUserStateChanged(user));
    }

    _usersBloc.stream.listen((postState) {
      if (!isClosed) {
        if (postState is UserAdded) {
          if (postState.user.id == _searchedUserId) {
            emit(SearchedUserStateChanged(postState.user));
          }
        }
      }
    });
  }

  // void _onCheckUserFollowingStateStarted(CheckIfUserIsFollowedStarted event,
  //     Emitter<SearchedUserState> state) async {
  //   try {
  //     emit(SearchedUserLoading());
  //     _isFollowed = await _dataRepository.checkIfUserFollowingSearched(
  //         receiverId: _searchedUserId);
  //     if (_isFollowed!) {
  //       emit(SearchedUserIsFollowed());
  //     } else
  //       emit(SearchedUserIsUnFollowed());
  //   } catch (e) {
  //     emit(SearchedUserError(e.toString()));
  //   }
  // }

  // void setFollowInitialValue(bool condition) {
  //   _isFollowed = condition;
  // }

  // get isFollowed => _isFollowed;

  get searchedUser => _searchedUser;

  List<PostModel> get posts => _posts;
}
