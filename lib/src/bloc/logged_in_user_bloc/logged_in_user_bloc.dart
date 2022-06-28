import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/auth_repository.dart';
import '../likes_bloc/likes_bloc.dart';

part 'logged_in_user_event.dart';

part 'logged_in_user_state.dart';

class LoggedInUserBloc extends Bloc<LoggedInUserEvent, LoggedInUserState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;
  final LikesBloc _likesBloc;

  LoggedInUserBloc(this._dataRepository,this._authRepository, this._likesBloc)
      : super(LoggedInUserInitial()) {
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    on<FetchLoggedInUserPostsStarted>(_onFetchLoggedInUserPosts);
    on<FetchLoggedInUserDetailsStarted>(_onFetchLoggedInUserDetailsStarted);
  }

  UserModel? loggedInUser;
  List<PostModel> _posts = [];

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


  Future<void> _onFetchLoggedInUserDetailsStarted(FetchLoggedInUserDetailsStarted event , emit)async{
    try{
      emit(LoggedInUserDetailsLoading());
      var loggedInUserData = await _dataRepository.getUserDetails(_authRepository.loggedInUser!.uid);
      loggedInUser = UserModel.fromJson(loggedInUserData.data() as Map<String , dynamic>);
      emit(LoggedInUserDetailsLoaded());
    }catch(e){
      emit(LoggedInUserError(e.toString()));
    }
  }

  void _onFetchLoggedInUserPosts(FetchLoggedInUserPostsStarted event,
      Emitter<LoggedInUserState> emit) async {
    try {
      List<PostModel> tempPosts = [];
      emit(LoggedInUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(loggedInUser!.id!)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);
        bool isLiked = await _dataRepository.checkIfUserLikesPost(
            loggedInUser!.id!, post.postId);
        _likesBloc.add(AddPostLikesInfoStarted(
            id: post.postId, likes: post.likesCount, isLiked: isLiked));
        tempPosts.add(post);

      });
      _posts = tempPosts;
      emit(_posts.isNotEmpty
          ? LoggedInUserPostsLoaded(_posts)
          : LoggedInUserEmptyPosts());
    } on Exception catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  List<PostModel> get posts => _posts;
}
