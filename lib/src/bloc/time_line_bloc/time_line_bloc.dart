import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model.dart';
import '../../repository/data_repository.dart';
import '../posts_bloc/posts_bloc.dart';

part 'time_line_event.dart';

part 'time_line_state.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final DataRepository _dataRepository;
  final PostsBloc _postsBloc;

  TimeLineBloc(this._dataRepository, this._postsBloc)
      : super(TimeLineInitial()) {
    on<FetchTimeLinePostsStarted>(_onFetchTimelinePostsStarted);
    on<ListenToTimelinePostsStarted>(_onListenToTimelinePostsStarted);
    on<AddNewUploadedPostStarted>(_onNewPostUploaded);
  }

  List<PostModel> _timelinePosts = [];
  PostModel? lastUploadedPost;
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

  void _onFetchTimelinePostsStarted(
      FetchTimeLinePostsStarted event, Emitter<TimeLineState> emit) async {
    try {
      List<QueryDocumentSnapshot> timelinePostsDocs = [];

      if (!event.nextList) {
        emit(FirstTimeLineLoading());
        _timelinePosts = [];
        isReachedToTheEnd = false;
        timelinePostsDocs = (await _dataRepository.getTimelinePostsIds()).docs;
      } else {
        emit(NextTimeLineLoading());
        timelinePostsDocs = (await _dataRepository.getTimelinePostsIds(
                documentSnapshot: lastDocument))
            .docs;
      }

      for (var doc in timelinePostsDocs) {
        PostModel? postResponse = await getPostResponse(doc.id);
        if (postResponse != null) {
          _postsBloc.addPost(postResponse);
          _timelinePosts.add(postResponse);
        }
      }
      if (timelinePostsDocs.isNotEmpty) {
        lastDocument = timelinePostsDocs.last;
      } else if (timelinePostsDocs.isEmpty && _timelinePosts.isNotEmpty) {
        isReachedToTheEnd = true;
      }
      // if (lastUploadedPost != null) {
      //   _timelinePosts.add(lastUploadedPost!);
      //   lastUploadedPost = null;
      // }

      emit(TimeLineLoaded(_timelinePosts));
    } on Exception catch (e) {
      print(e.toString());
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

  Future<PostModel?> getPostResponse(String id) async {
    final postData = await _dataRepository.getPostDetails(
      postId: id,
    );

    if (postData != null) {
      PostModel post =
          PostModel.fromJson(postData.data() as Map<String, dynamic>);
      // get user data to add profile photo and username
      final userData = (await _dataRepository.getUserDetails(post.publisherId))
          .data() as Map<String, dynamic>;
      UserModel user = UserModel.fromJson(userData);
      post.owner = user;

      bool isLiked = await _dataRepository.checkIfUserLikesPost(post.postId);
      post.isLiked = isLiked;
      return post;
    }
    return null;
  }

  List<PostModel> get posts => _timelinePosts;

  void addUploadedPost(PostModel postResponse) {
    lastUploadedPost = postResponse;
  }
}
