import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:meta/meta.dart';
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
    // on<ListenToTimelinePostsStarted>(_onListenToTimelinePostsStarted);
    on<AddNewUploadedPostStarted>(_onNewPostUploaded);
  }

  List<PostModel> _posts = [];
  int oldTotal = 0;
  int newTotal = 0;

  void _onFetchTimelinePostsStarted(
      FetchTimeLinePostsStarted event, Emitter<TimeLineState> emit) async {
    try {
      emit(TimeLineLoading());

      // 1) get posts ids
      QuerySnapshot? timelinePostsQuerySnapshot = (await _dataRepository
          .getTimelinePostsIds(_dataRepository.loggedInUserId));

      // 2) get every post data that related to it's id
      if (timelinePostsQuerySnapshot != null &&
          timelinePostsQuerySnapshot.docs.isNotEmpty) {
        List<PostModel> postsTemp = [];
        for (var doc in timelinePostsQuerySnapshot.docs) {
          final postData = await _dataRepository.getPostDetails(
            postId: doc.id,
          );

          if (postData != null) {
            PostModel post = PostModel.fromJson(postData.data()!);
            // 3) check if logged in user liked this post
            bool isLiked = await _dataRepository.checkIfUserLikesPost(
                _dataRepository.loggedInUserId, post.postId);
            _likesBloc.add(AddPostLikesInfoStarted(
                id: post.postId, likes: post.likesCount, isLiked: isLiked));

            postsTemp.add(post);
          }
        }
        _posts = postsTemp;
        emit(_posts.isNotEmpty ? TimeLineLoaded(_posts) : EmptyTimeline());
        // add(ListenToTimelinePostsStarted());
      } else {
        emit(EmptyTimeline());
      }
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }

  // void _onListenToTimelinePostsStarted(
  //     ListenToTimelinePostsStarted event, Emitter<TimeLineState> emit) async {
  //   try {
  //     _dataRepository
  //         .listenToTimeline(_dataRepository.loggedInUserId)
  //         .listen((event) {
  //       oldTotal = event.data()!["total"];
  //       if (oldTotal != newTotal) {
  //         oldTotal = newTotal;
  //         // emit(TimeLineChanged());
  //       }
  //     });
  //   } on Exception catch (e) {
  //     emit(TimeLineError(e.toString()));
  //   }
  // }

  Future<void> _onNewPostUploaded(
      AddNewUploadedPostStarted event, Emitter<TimeLineState> emit) async {
    // _likesBloc.add(AddPostLikesInfoStarted(
    //     id: event.post.postId, likes: event.post.likesCount, isLiked: false));
    //
    // _posts.add(event.post);
    // emit(NewUploadedPostAdded());
  }

  // void _onListenToTimelinePostsStarted(ListenToTimelinePostsStarted event, Emitter<TimeLineState> emit)async{
  //   try {
  //     emit(TimeLineLoading());
  //
  //     // 1) get posts ids
  //     final timelinePostsData =
  //     _dataRepository.listenToTimelinePostsIds(_userId);
  //
  //     // 2) get every post data that related to it's id
  //     await for (var eventItem in timelinePostsData) {
  //       List<PostModel> postsTemp = [];
  //       for (var doc in eventItem.docs) {
  //         if (doc.data().isNotEmpty) {
  //           final postData = await _dataRepository.getPostDetails(
  //             postId: doc.id,
  //           );
  //           PostModel post = PostModel.fromJson(postData.data()!);
  //           // 3) check if logged in user liked this post
  //           bool isLiked = await _dataRepository.checkIfUserLikesPost(
  //               _userId, post.postId);
  //           _likesBloc.add(AddPostLikesInfoStarted(
  //               id: post.postId, likes: post.likesCount, isLiked: isLiked));
  //
  //           postsTemp.add(post);
  //         }
  //       }
  //       _posts = postsTemp;
  //       emit(_posts.isNotEmpty ? TimeLineLoaded(_posts) : EmptyTimeline());
  //     }
  //   } on Exception catch (e) {
  //     emit(TimeLineError(e.toString()));
  //   }
  // }

  List<PostModel> get posts => _posts;
}
