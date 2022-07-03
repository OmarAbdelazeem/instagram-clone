import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model_request/post_model_request.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/auth_repository.dart';
import '../likes_bloc/likes_bloc.dart';

part 'logged_in_user_event.dart';

part 'logged_in_user_state.dart';

enum UserData { bio, name }

class LoggedInUserBloc extends Bloc<LoggedInUserEvent, LoggedInUserState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;
  final LikesBloc _likesBloc;

  LoggedInUserBloc(this._dataRepository, this._authRepository, this._likesBloc)
      : super(LoggedInUserInitial()) {
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    on<FetchLoggedInUserPostsStarted>(_onFetchLoggedInUserPosts);
    on<UpdateUserDataEventStarted>(_onUpdateUserDataStarted);
    on<FetchLoggedInUserDetailsStarted>(_onFetchLoggedInUserDetailsStarted);
  }

  UserModel? loggedInUser;
  List<PostModelResponse> _posts = [];

  _onListenToLoggedInUserStarted(ListenToLoggedInUserStarted event, state) {
    try {
      _dataRepository
          .listenToUserDetails(loggedInUser!.id!)
          .listen((streamEvent) {
        if (streamEvent.data() != null) {
          loggedInUser =
              UserModel.fromJson(streamEvent.data() as Map<String, dynamic>);
          emit(LoggedInUserLoaded());
        }
      });
    } catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  _onSetLoggedInUserStarted(SetLoggedInUserStarted event, emit) {
    loggedInUser = event.user;
  }

  Future<void> _onFetchLoggedInUserDetailsStarted(
      FetchLoggedInUserDetailsStarted event, emit) async {
    try {
      emit(LoggedInUserDetailsLoading());
      var loggedInUserData = await _dataRepository
          .getUserDetails(_authRepository.loggedInUser!.uid);
      loggedInUser =
          UserModel.fromJson(loggedInUserData.data() as Map<String, dynamic>);
      emit(LoggedInUserDetailsLoaded());
    } catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  void _onFetchLoggedInUserPosts(FetchLoggedInUserPostsStarted event,
      Emitter<LoggedInUserState> emit) async {
    try {
      List<PostModelResponse> tempPosts = [];
      emit(LoggedInUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(loggedInUser!.id!)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModelRequest postRequest =
            PostModelRequest.fromJson(item.data() as Map<String, dynamic>);
        // get user data to add profile photo and username
        final userData =
            await _dataRepository.getUserDetails(postRequest.publisherId);
        UserModel user =
            UserModel.fromJson(userData.data() as Map<String, dynamic>);

        PostModelResponse postResponse =
            PostModelResponse.getDataFromPostRequestAndUser(postRequest, user);

        bool isLiked =
            await _dataRepository.checkIfUserLikesPost(postResponse.postId);
        _likesBloc.add(AddPostLikesInfoStarted(
            id: postResponse.postId,
            likes: postResponse.likesCount,
            isLiked: isLiked));
        tempPosts.add(postResponse);
      });
      _posts = tempPosts;
      emit(_posts.isNotEmpty
          ? LoggedInUserPostsLoaded(_posts)
          : LoggedInUserEmptyPosts());
    } on Exception catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserDataStarted(
      UpdateUserDataEventStarted event, emit) async {
    try {
      emit(UpdatingUserData());
      String fieldName;
      switch (event.userData) {
        case UserData.name:
          fieldName = "userName";
          await _dataRepository.updateUserData({fieldName: event.value});
          loggedInUser!.userName = event.value;
          break;
        case UserData.bio:
          fieldName = "bio";
          await _dataRepository.updateUserData({fieldName: event.value});
          loggedInUser!.bio = event.value;
          break;
      }

      emit(UpdatedUserData());
    } catch (e) {
      emit(UpdateUserDataError(e.toString()));
      print(e.toString());
    }
  }

  List<PostModelResponse> get posts => _posts;
}
