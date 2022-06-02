import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../core/saved_posts_likes.dart';
import '../../repository/data_repository.dart';
import '../likes_bloc/likes_bloc.dart';

part 'searched_user_event.dart';

part 'searched_user_state.dart';

class SearchedUserBloc extends Bloc<SearchedUserEvent, SearchedUserState> {
  final DataRepository _dataRepository;
  final String _loggedInUserId;
  final String _searchedUserId;
  final LikesBloc _likesBloc;
  final FollowingBloc _followingBloc;

  SearchedUserBloc(this._dataRepository, this._likesBloc, this._loggedInUserId,
      this._searchedUserId, this._followingBloc)
      : super(SearchedUserInitial()) {
    on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    on<FollowUserEventStarted>(_onFollowStarted);
    on<UnFollowUserEventStarted>(_onUnFollowStarted);
    on<CheckIfUserIsFollowedStarted>(_onCheckUserFollowingStateStarted);
    on<FetchSearchedUserPostsStarted>(_onFetchSearchedUserPostsStarted);
  }

  List<PostModel> _posts = [];
  UserModel? _searchedUser;
  bool? _isFollowed;
  Map<String, dynamic> userData = {};

  _onListenToSearchedUserStarted(
      ListenToSearchedUserStarted event, Emitter<SearchedUserState> state) {
    try {
      _dataRepository
          .listenToUserDetails(_searchedUserId)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          _searchedUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          if(!isClosed)
          emit(SearchedUserLoaded(_searchedUser!));
        }
      });
    } catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onFetchSearchedUserPostsStarted(FetchSearchedUserPostsStarted event,
      Emitter<SearchedUserState> emit) async {
    try {
      emit(SearchedUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(_searchedUserId)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);

        bool isLiked = await _dataRepository.checkIfUserLikesPost(
            _loggedInUserId, post.postId);

        _likesBloc.add(AddPostLikesInfoStarted(
            id: post.postId, likes: post.likesCount, isLiked: isLiked));
        _posts.add(post);
      });

      emit(_posts.isNotEmpty
          ? SearchedUserPostsLoaded(_posts)
          : SearchedUserEmptyPosts());
    } on Exception catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onFollowStarted(
      FollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsFollowed());
      _followingBloc.add(AddFollowerIdStarted(_searchedUserId));
      _isFollowed = true;
      await _dataRepository.addFollower(
          receiverId: _searchedUserId, senderId: _loggedInUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsUnFollowed());
      _followingBloc.add(RemoveFollowerIdStarted(_searchedUserId));
      _isFollowed = false;
      await _dataRepository.removeFollower(
          receiverId: _searchedUserId, senderId: _loggedInUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onCheckUserFollowingStateStarted(CheckIfUserIsFollowedStarted event,
      Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserLoading());
      _isFollowed = await _dataRepository.checkIfUserFollowingSearched(
          receiverId: _searchedUserId, senderId: _loggedInUserId);
      if (_isFollowed!) {
        emit(SearchedUserIsFollowed());
      } else
        emit(SearchedUserIsUnFollowed());
    } catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void setFollowInitialValue(bool condition) {
    _isFollowed = condition;
  }

  get isFollowed => _isFollowed;

  get searchedUser => _searchedUser;

  List<PostModel> get posts => _posts;
}
