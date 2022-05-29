import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../models/post_model/post_model.dart';
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

  List<PostModel> _posts = [];

  void _onFetchExplorePostsPostsStarted(
      FetchExplorePostsStarted event, Emitter<ExplorePostsState> emit) async {
    try {
      emit(ExplorePostsLoading());
      final data = (await _dataRepository.getExplorePosts(userId)).docs;
      List<PostModel> postsTemp = [];
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);
        bool isLiked =
            await _dataRepository.checkIfUserLikesPost(userId, post.postId);
        _likesBloc.add(AddPostLikesInfoStarted(
            id: post.postId, likes: post.likesCount, isLiked: isLiked));
        postsTemp.add(post);
      });
      _posts = postsTemp;
      emit(
          _posts.isNotEmpty ? ExplorePostsLoaded(_posts) : ExplorePostsEmpty());
    } on Exception catch (e) {
      emit(ExplorePostsError(e.toString()));
    }
  }

  List<PostModel> get posts => _posts;
}
