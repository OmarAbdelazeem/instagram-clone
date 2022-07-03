import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../models/post_model/post_model_request/post_model_request.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';
import '../likes_bloc/likes_bloc.dart';

part 'explore_posts_event.dart';

part 'explore_posts_state.dart';

class ExplorePostsBloc extends Bloc<ExplorePostsEvent, ExplorePostsState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;
  final String userId;

  ExplorePostsBloc(this.userId, this._likesBloc, this._dataRepository)
      : super(ExplorePostsInitial()) {
    on<FetchExplorePostsStarted>(_onFetchExplorePostsPostsStarted);
  }

  List<PostModelResponse> _posts = [];

  void _onFetchExplorePostsPostsStarted(
      FetchExplorePostsStarted event, Emitter<ExplorePostsState> emit) async {
    try {
      emit(ExplorePostsLoading());
      final data = (await _dataRepository.getExplorePosts(userId)).docs;
      List<PostModelResponse> postsTemp = [];
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

        bool isLiked = await _dataRepository.checkIfUserLikesPost(userId);
        _likesBloc.add(AddPostLikesInfoStarted(
            id: postResponse.postId,
            likes: postResponse.likesCount,
            isLiked: isLiked));
        postsTemp.add(postResponse);
      });
      _posts = postsTemp;
      emit(
          _posts.isNotEmpty ? ExplorePostsLoaded(_posts) : ExplorePostsEmpty());
    } on Exception catch (e) {
      emit(ExplorePostsError(e.toString()));
    }
  }

  List<PostModelResponse> get posts => _posts;
}
