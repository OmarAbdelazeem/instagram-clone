import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:meta/meta.dart';

import '../../core/saved_posts_likes.dart';
import '../../models/post_model/post_model.dart';
import '../../repository/data_repository.dart';

part 'time_line_event.dart';

part 'time_line_state.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;


  TimeLineBloc(this._dataRepository, this._likesBloc)
      : super(TimeLineInitial()) {
    on<FetchTimeLinePostsStarted>(_onFetchTimelinePostsStarted);
  }

  List<PostModel> _posts = [];

  void _onFetchTimelinePostsStarted(
      FetchTimeLinePostsStarted event, Emitter<TimeLineState> emit) async {
    try {
      emit(TimeLineLoading());

      // 1) get posts ids
      final timelinePostsData =
          _dataRepository.listenToTimelinePostsIds(event.userId);

      // 2) get every post data that related to it's id
      await for (var eventItem in timelinePostsData) {
        List<PostModel> postsTemp = [];
        for (var doc in eventItem.docs) {
          if (doc.data().isNotEmpty) {
            final postData = await _dataRepository.getPostDetails(
              postId: doc.id,
            );
            PostModel post = PostModel.fromJson(postData.data()!);
            // 3) check if logged in user liked this post
            bool isLiked = await _dataRepository.checkIfUserLikesPost(
                event.userId, post.postId);
            _likesBloc.add(AddPostLikesInfoStarted(
                id: post.postId, likes: post.likesCount, isLiked: isLiked));

            postsTemp.add(post);
          }
        }
        _posts = postsTemp;
        emit(TimeLineLoaded(_posts));
      }
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }

  List<PostModel> get posts => _posts;
}
