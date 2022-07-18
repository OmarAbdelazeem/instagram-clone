import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagramapp/src/core/utils/initialize_post.dart';
import 'package:meta/meta.dart';

import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';
import '../../repository/posts_repository.dart';
import '../posts_bloc/posts_bloc.dart';

part 'explore_posts_event.dart';

part 'explore_posts_state.dart';

class ExplorePostsBloc extends Bloc<ExplorePostsEvent, ExplorePostsState> {
  final DataRepository _dataRepository;
  final PostsBloc _postsBloc;

  ExplorePostsBloc(this._postsBloc, this._dataRepository)
      : super(ExplorePostsInitial()) {
    on<FetchExplorePostsStarted>(_onFetchExplorePostsPostsStarted);
  }

  List<PostModel> _explorePosts = [];
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

  void _onFetchExplorePostsPostsStarted(
      FetchExplorePostsStarted event, Emitter<ExplorePostsState> emit) async {
    try {
      List<QueryDocumentSnapshot> explorePostsDocs = [];

      if (!event.nextList) {
        emit(FirstExplorePostsLoading());
        _explorePosts = [];
        isReachedToTheEnd = false;
        explorePostsDocs = (await _dataRepository.getExplorePosts()).docs;
      } else {
        emit(NextExplorePostsLoading());
        explorePostsDocs = (await _dataRepository.getExplorePosts(
                documentSnapshot: lastDocument))
            .docs;
      }

      for (var doc in explorePostsDocs) {
        PostModel postResponse =
            await initializePost(doc.data() as Map<String, dynamic>,_dataRepository);
        _postsBloc.addPost(postResponse);
        _explorePosts.add(postResponse);
      }

      if (explorePostsDocs.isNotEmpty) {
        lastDocument = explorePostsDocs.last;
      } else if (explorePostsDocs.isEmpty && _explorePosts.isNotEmpty) {
        isReachedToTheEnd = true;
      }

      emit(ExplorePostsLoaded(_explorePosts));
    } on Exception catch (e) {
      emit(ExplorePostsError(e.toString()));
    }
  }



  List<PostModel> get explorePosts => _explorePosts;
}
