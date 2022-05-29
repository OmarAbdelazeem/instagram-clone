import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';

import '../../core/saved_posts_likes.dart';
import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../likes_bloc/likes_bloc.dart';

part 'logged_in_user_event.dart';

part 'logged_in_user_state.dart';

class LoggedInUserBloc extends Bloc<LoggedInUserEvent, LoggedInUserState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;

  LoggedInUserBloc(this._dataRepository, this._likesBloc)
      : super(LoggedInUserInitial()) {
    on<ListenToLoggedInUserStarted>(_onListenToLoggedInUserStarted);
    on<SetLoggedInUserStarted>(_onSetLoggedInUserStarted);
    on<FetchLoggedInUserPostsStarted>(_onFetchLoggedInUserPosts);
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

  void _onFetchLoggedInUserPosts(FetchLoggedInUserPostsStarted event,
      Emitter<LoggedInUserState> emit) async {
    try {
      emit(LoggedInUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(loggedInUser!.id!)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);
        bool isLiked = await _dataRepository.checkIfUserLikesPost(
            loggedInUser!.id!, post.postId);
        _likesBloc.add(AddPostLikesInfoStarted(
            id: post.postId, likes: post.likesCount, isLiked: isLiked));
        posts.add(post);
        // posts.add(post);
        // posts.add(post);
        // posts.add(post);
        // posts.add(post);
        // posts.add(post);
      });

      emit(_posts.isNotEmpty
          ? LoggedInUserPostsLoaded(_posts)
          : LoggedInUserEmptyPosts());
    } on Exception catch (e) {
      emit(LoggedInUserError(e.toString()));
    }
  }

  List<PostModel> get posts => _posts;
}
