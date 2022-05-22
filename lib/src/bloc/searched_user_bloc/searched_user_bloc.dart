import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../core/saved_posts_likes.dart';
import '../../repository/data_repository.dart';

part 'searched_user_event.dart';

part 'searched_user_state.dart';

class SearchedUserBloc extends Bloc<SearchedUserEvent, SearchedUserState> {
  final DataRepository _dataRepository;

  SearchedUserBloc(this._dataRepository) : super(SearchedUserInitial()) {
    on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    on<SetSearchedUserIdStarted>(_onSetSearchedUserIdStarted);
    on<FollowUserEventStarted>(_onFollowStarted);
    on<UnFollowUserEventStarted>(_onUnFollowStarted);
    on<CheckIfUserIsFollowedStarted>(_onCheckUserFollowingStateStarted);
    on<FetchSearchedUserPostsStarted>(_onFetchSearchedUserPostsStarted);
  }

  List<PostModel> _posts = [];
  UserModel? _searchedUser;
  bool? _isFollowed;
  String? _searchedUserId;


  _onListenToSearchedUserStarted(
      ListenToSearchedUserStarted event, Emitter<SearchedUserState> state) {
    try {
      _dataRepository
          .listenToUserDetails(_searchedUserId!)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          _searchedUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          emit(SearchedUserLoaded(_searchedUser!));
        }
      });
    } catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  _onSetSearchedUserIdStarted(
      SetSearchedUserIdStarted event, Emitter<SearchedUserState> state) {
    _searchedUserId = event.searchedUserId;
  }

  void _onFetchSearchedUserPostsStarted(FetchSearchedUserPostsStarted event,
      Emitter<SearchedUserState> emit) async {
    try {
      emit(SearchedUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(_searchedUserId!)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);
        bool isLiked = await _dataRepository.checkIfUserLikesPost(
            _searchedUserId!, post.postId);
        if (isLiked)
          SavedPostsLikes.addPostIdToLikes(
              id: post.postId, likes: post.likesCount);
        _posts.add(post);
      });

      emit(SearchedUserPostsLoaded(_posts));
    } on Exception catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onFollowStarted(
      FollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsFollowed());
      _isFollowed = true;
      await _dataRepository.addFollower(
          receiverId: _searchedUserId!, senderId: event.loggedInUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsUnFollowed());
      _isFollowed = false;
      await _dataRepository.removeFollower(
          receiverId: _searchedUserId!, senderId: event.loggedInUserId);
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
          receiverId: _searchedUserId!, senderId: event.loggedInUserId);
      if (_isFollowed!) {
        emit(SearchedUserIsFollowed());
      } else
        emit(SearchedUserIsUnFollowed());
    } catch (e) {
      emit(SearchedUserError(e.toString()));
    }
  }

  get isFollowed => _isFollowed;

  get searchedUser => _searchedUser;

  List<PostModel> get posts => _posts;
}