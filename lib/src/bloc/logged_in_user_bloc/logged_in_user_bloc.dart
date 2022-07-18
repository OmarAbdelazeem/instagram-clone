import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/core/utils/initialize_post.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';

import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/auth_repository.dart';
import '../../repository/posts_repository.dart';
import '../posts_bloc/posts_bloc.dart';

part 'logged_in_user_event.dart';

part 'logged_in_user_state.dart';

enum UserData { bio, name }

class LoggedInUserBloc extends Bloc<LoggedInUserEvent, LoggedInUserState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;
  final PostsBloc _postsBloc;

  LoggedInUserBloc(
    this._dataRepository,
    this._authRepository,
    this._postsBloc,
  ) : super(LoggedInUserInitial()) {
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    on<FetchLoggedInUserPostsStarted>(_onFetchLoggedInUserPosts);
    on<UpdateUserDataEventStarted>(_onUpdateUserDataStarted);
    on<FetchLoggedInUserDetailsStarted>(_onFetchLoggedInUserDetailsStarted);
  }

  UserModel? loggedInUser;
  List<PostModel> _posts = [];
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

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

  Future<void> _onFetchLoggedInUserPosts(FetchLoggedInUserPostsStarted event,
      Emitter<LoggedInUserState> emit) async {
    try {
      List<QueryDocumentSnapshot> postsDocs = [];

      if (!event.nextList) {
        emit(LoggedInUserFirstPostsLoading());
        _posts = [];
        isReachedToTheEnd = false;
        postsDocs =
            (await _dataRepository.getUserPosts(userId: loggedInUser!.id!))
                .docs;
      } else {
        emit(LoggedInUserNextPostsLoading());
        postsDocs = (await _dataRepository.getUserPosts(
                userId: loggedInUser!.id!, documentSnapshot: lastDocument))
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

      emit(LoggedInUserPostsLoaded(_posts));
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

  List<PostModel> get posts => _posts;
}
