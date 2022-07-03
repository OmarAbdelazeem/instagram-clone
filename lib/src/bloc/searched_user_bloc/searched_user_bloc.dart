import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model_request/post_model_request.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../repository/data_repository.dart';
import '../likes_bloc/likes_bloc.dart';

part 'searched_user_event.dart';

part 'searched_user_state.dart';

class SearchedUserBloc extends Bloc<SearchedUserEvent, SearchedUserState> {
  final DataRepository dataRepository;
  final String searchedUserId;
  final LikesBloc likesBloc;
  final FollowingBloc followingBloc;

  SearchedUserBloc(
      {required this.dataRepository,
      required this.likesBloc,
      required this.searchedUserId,
      required this.followingBloc})
      : super(SearchedUserInitial()) {
    on<ListenToSearchedUserStarted>(_onListenToSearchedUserStarted);
    on<FollowUserEventStarted>(_onFollowStarted);
    on<UnFollowUserEventStarted>(_onUnFollowStarted);
    on<CheckIfUserIsFollowedStarted>(_onCheckUserFollowingStateStarted);
    on<FetchSearchedUserPostsStarted>(_onFetchSearchedUserPostsStarted);
  }

  List<PostModelResponse> _posts = [];
  UserModel? _searchedUser;
  bool? _isFollowed;
  Map<String, dynamic> userData = {};

  _onListenToSearchedUserStarted(
      ListenToSearchedUserStarted event, Emitter<SearchedUserState> state) {
    try {
      dataRepository
          .listenToUserDetails(searchedUserId)
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
      emit(SearchedUserPostsLoading());
      final data = (await dataRepository.getUserPosts(searchedUserId)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModelRequest postRequest =
        PostModelRequest.fromJson(item.data() as Map<String, dynamic>);
        // get user data to add profile photo and username
        final userData =
        await dataRepository.getUserDetails(postRequest.publisherId);
        UserModel user =
        UserModel.fromJson(userData.data() as Map<String, dynamic>);
        PostModelResponse postResponse = PostModelResponse
            .getDataFromPostRequestAndUser(postRequest, user);
        bool isLiked = await dataRepository.checkIfUserLikesPost(postResponse.postId);

        likesBloc.add(AddPostLikesInfoStarted(
            id: postResponse.postId, likes: postResponse.likesCount, isLiked: isLiked));
        _posts.add(postResponse);
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
      followingBloc.add(AddFollowerIdStarted(searchedUserId));
      _isFollowed = true;
      await dataRepository.addFollower(receiverId: searchedUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowUserEventStarted event, Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserIsUnFollowed());
      followingBloc.add(RemoveFollowerIdStarted(searchedUserId));
      _isFollowed = false;
      await dataRepository.removeFollower(
          receiverId: searchedUserId);
    } catch (e) {
      print(e.toString());
      emit(SearchedUserError(e.toString()));
    }
  }

  void _onCheckUserFollowingStateStarted(CheckIfUserIsFollowedStarted event,
      Emitter<SearchedUserState> state) async {
    try {
      emit(SearchedUserLoading());
      _isFollowed = await dataRepository.checkIfUserFollowingSearched(
          receiverId: searchedUserId);
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

  List<PostModelResponse> get posts => _posts;
}
