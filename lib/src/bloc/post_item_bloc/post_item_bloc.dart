import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model_request/comment_model_request.dart';
import 'package:instagramapp/src/models/comment_model/comment_model_response/comment_model_response.dart';
import 'package:instagramapp/src/models/likes_info_model/likes_info_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';
import '../../models/post_model/post_model_request/post_model_request.dart';
import '../../models/post_model/post_model_response/post_model_response.dart';
import '../../models/user_model/user_model.dart';

part 'post_item_event.dart';

part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  final DataRepository dataRepository;
  final LikesBloc likesBloc;
  PostModelResponse? post;

  PostItemBloc(
      {required this.dataRepository, required this.likesBloc, this.post})
      : super(PostItemInitial()) {
    on<AddLikeStarted>(_onAddLikeStarted);
    on<RemoveLikeStarted>(_onRemoveLikeStarted);
    on<LoadCommentsStarted>(_onLoadCommentsStarted);
    on<AddCommentStarted>(_onAddCommentStarted);
    on<CheckIfPostIsLikedStarted>(_onCheckIfPostIsLikedStarted);
    on<FetchPostDetailsStarted>(_onFetchPostDetailsStarted);
  }

  List<CommentModelResponse> comments = [];
  bool _isLiked = false;

  FutureOr<void> _onAddLikeStarted(
      AddLikeStarted event, Emitter<PostItemState> state) async {
    try {
      emit(PostIsLiked());
      _isLiked = true;
      post!.likesCount++;
      likesBloc.add(AddPostLikesInfoStarted(
          isLiked: true, id: post!.postId, likes: post!.likesCount));

      await dataRepository.addLikeToPost(
          postId: event.postId, userId: event.userId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onRemoveLikeStarted(
      RemoveLikeStarted event, Emitter<PostItemState> state) async {
    try {
      emit(PostIsUnLiked());
      _isLiked = false;
      post!.likesCount--;
      likesBloc.add(AddPostLikesInfoStarted(
          isLiked: false, id: post!.postId, likes: post!.likesCount));

      await dataRepository.removeLikeFromPost(
          postId: event.postId, publisherId: event.userId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onLoadCommentsStarted(
      LoadCommentsStarted event, Emitter<PostItemState> state) async {
    try {
      emit(CommentsLoading());
      final commentsData = await dataRepository.getPostComments(event.postId);

      List<CommentModelResponse> commentsTemp = [];
      for (var commentRequestData in commentsData.docs) {
        CommentModelRequest commentRequest =
            CommentModelRequest.fromJson(commentRequestData.data());
        final userData =
            await dataRepository.getUserDetails(commentRequest.publisherId);
        UserModel user =
            UserModel.fromJson(userData.data() as Map<String, dynamic>);
        CommentModelResponse commentResponse =
            CommentModelResponse.getDataFromCommentRequestAndUser(
                commentRequest, user);
        commentsTemp.add(commentResponse);
      }
      comments = commentsTemp;
      emit(CommentsLoaded(comments));
    } catch (e) {}
  }

  FutureOr<void> _onAddCommentStarted(
      AddCommentStarted event, Emitter<PostItemState> state) async {
    try {
      emit(AddingComment(event.comment.commentId!));
      comments.add(event.comment);
      await dataRepository
          .addComment(CommentModelRequest.fromCommentResponse(event.comment));
      emit(CommentAdded());
    } catch (e) {
      print(e.toString());
    }
  }

  _onCheckIfPostIsLikedStarted(
      CheckIfPostIsLikedStarted event, Emitter<PostItemState> state) {
    /// 1) initialize likes count and check if post isLiked
    getInitialValueOfLikes();

    /// 2) listen to likes count check if post isLiked if there is another event
    likesBloc.stream.listen((likesState) {
      if (likesState is LikesChanged) {
        LikesInfo likesInfo = likesBloc.getPostLikesInfo(post!.postId)!;
        _isLiked = likesInfo.isLiked;
        post!.likesCount = likesInfo.likes;
        if (!isClosed) {
          if (_isLiked) {
            emit(PostIsLiked());
          } else {
            emit(PostIsUnLiked());
          }
        }
      }
    });
  }

  _onFetchPostDetailsStarted(
      FetchPostDetailsStarted event, Emitter<PostItemState> state) async {
    emit(PostLoading());
    try {
      final postData =
          await dataRepository.getPostDetails(postId: event.postId);

      if (postData != null) {
        PostModelRequest postRequest =
            PostModelRequest.fromJson(postData.data() as Map<String, dynamic>);
        // get user data to add profile photo and username
        final userData =
            await dataRepository.getUserDetails(postRequest.publisherId);
        UserModel user =
            UserModel.fromJson(userData.data() as Map<String, dynamic>);

        PostModelResponse postResponse =
            PostModelResponse.getDataFromPostRequestAndUser(postRequest, user);
        post = postResponse;
        bool isLiked =
            await dataRepository.checkIfUserLikesPost(postResponse.postId);
        likesBloc.add(AddPostLikesInfoStarted(
            id: postResponse.postId,
            likes: postResponse.likesCount,
            isLiked: isLiked));
        emit(PostLoaded(postResponse));
      }
    } catch (e) {
      print(e.toString());
      emit(PostItemError(e.toString()));
    }
  }

  void getInitialValueOfLikes() {
    LikesInfo likesInfo = likesBloc.getPostLikesInfo(post!.postId)!;
    _isLiked = likesInfo.isLiked;
    post!.likesCount = likesInfo.likes;
    if (_isLiked) {
      emit(PostIsLiked());
    } else {
      emit(PostIsUnLiked());
    }
  }

  bool get isLiked => _isLiked;

  PostModelResponse? get currentPost => post!;
}
