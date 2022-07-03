import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model_request/post_model_request.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../repository/data_repository.dart';

part 'time_line_event.dart';

part 'time_line_state.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;

  TimeLineBloc(this._dataRepository, this._likesBloc)
      : super(TimeLineInitial()) {
    on<FetchTimeLinePostsStarted>(_onFetchTimelinePostsStarted);
    on<ListenToTimelinePostsStarted>(_onListenToTimelinePostsStarted);
    on<AddNewUploadedPostStarted>(_onNewPostUploaded);
  }

  List<PostModelResponse> _posts = [];
  PostModelResponse? lastUploadedPost;

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
        List<PostModelResponse> postsTemp = [];
        if(lastUploadedPost !=null){
          postsTemp.add(lastUploadedPost!);
          lastUploadedPost = null;
        }
        for (var doc in timelinePostsQuerySnapshot.docs) {
          PostModelResponse? postResponse = await getPostData(doc.id);
          if (postResponse != null) postsTemp.add(postResponse);
        }
        _posts = postsTemp;

        emit(_posts.isNotEmpty ? TimeLineLoaded(_posts) : EmptyTimeline());

      } else {
        emit(EmptyTimeline());
      }
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }

  void _onListenToTimelinePostsStarted(
      ListenToTimelinePostsStarted event, Emitter<TimeLineState> emit) async {
    try {
      var postsIdsStream =
          _dataRepository.listenToTimeline(_dataRepository.loggedInUserId);
      await for (var docStream in postsIdsStream) {
        for (var doc in docStream.docs) {

          // if (doc.id == _lastUploadedPostId) {
          //   PostModelResponse? postResponse = await getPostData(doc.id);
          //   if (postResponse != null){
          //     print("_posts length is ${_posts.length}");
          //     emit(TimeLineLoading());
          //     _posts.insert(0, postResponse);
          //
          //     emit(TimeLineLoaded(_posts));
          //     _lastUploadedPostId = null;
          //     print("_posts length is ${_posts.length}");
          //   }
          //
          // }
        }
      }
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }

  /*

   */

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



  Future<PostModelResponse?> getPostData(String id) async {
    final postData = await _dataRepository.getPostDetails(
      postId: id,
    );

    if (postData != null) {
      PostModelRequest postRequest =
          PostModelRequest.fromJson(postData.data()!);
      //3) get user data to add profile photo and username
      final userData =
          await _dataRepository.getUserDetails(postRequest.publisherId);
      UserModel user =
          UserModel.fromJson(userData.data() as Map<String, dynamic>);

      PostModelResponse postResponse =
          PostModelResponse.getDataFromPostRequestAndUser(postRequest, user);
      // 4) check if logged in user liked this post
      bool isLiked =
          await _dataRepository.checkIfUserLikesPost(postRequest.postId);
      _likesBloc.add(AddPostLikesInfoStarted(
          id: postRequest.postId,
          likes: postRequest.likesCount,
          isLiked: isLiked));

      return postResponse;
    }
    return null;
  }

  List<PostModelResponse> get posts => _posts;

  void addUploadedPost(PostModelResponse postResponse){
    lastUploadedPost = postResponse;
  }

}
