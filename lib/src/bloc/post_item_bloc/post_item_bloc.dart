import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/core/utils/initialize_post.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/posts_repository.dart';
import 'package:meta/meta.dart';
import '../../models/comment_model/comment_model.dart';
import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../posts_bloc/posts_bloc.dart';

part 'post_item_event.dart';

part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  final DataRepository dataRepository;
  final PostsBloc postsBloc;
  PostModel? currentPost;

  PostItemBloc({
    required this.dataRepository,
    required this.postsBloc,
    this.currentPost,
  }) : super(PostItemInitial()) {
    on<AddLikeStarted>(_onAddLikeStarted);
    on<RemoveLikeStarted>(_onRemoveLikeStarted);
    on<FetchCommentsStarted>(_onLoadCommentsStarted);
    on<AddCommentStarted>(_onAddCommentStarted);
    on<ListenForPostUpdatesStarted>(_onListenForPostUpdatesStarted);
    on<FetchPostDetailsStarted>(_onFetchPostDetailsStarted);
    on<PostEditStarted>(_onEditPostCaptionStarted);
  }

  List<CommentModel> _comments = [];
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

  FutureOr<void> _onAddLikeStarted(
      AddLikeStarted event, Emitter<PostItemState> state) async {
    try {
      currentPost!.likesCount++;
      currentPost!.isLiked = true;
      postsBloc.add(UpdatePostStarted(currentPost!));

      await dataRepository.addLikeToPost(postId: event.postId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onRemoveLikeStarted(
      RemoveLikeStarted event, Emitter<PostItemState> state) async {
    try {
      currentPost!.likesCount--;
      currentPost!.isLiked = false;
      postsBloc.add(UpdatePostStarted(currentPost!));
      await dataRepository.removeLikeFromPost(postId: event.postId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onLoadCommentsStarted(
      FetchCommentsStarted event, Emitter<PostItemState> state) async {
    try {
      List<QueryDocumentSnapshot> commentsDocs = [];

      if (!event.nextList) {
        emit(FirstCommentsLoading());
        _comments = [];
        isReachedToTheEnd = false;
        commentsDocs =
            (await dataRepository.getPostComments(postId: event.postId)).docs;
      } else {
        emit(NextCommentsLoading());
        commentsDocs = (await dataRepository.getPostComments(
                postId: event.postId, documentSnapshot: lastDocument))
            .docs;
      }

      for (var doc in commentsDocs) {
        CommentModel comment =
            await _getCommentResponse(doc.data() as Map<String, dynamic>);
        _comments.add(comment);
      }

      if (commentsDocs.isNotEmpty) {
        lastDocument = commentsDocs.last;
      } else if (commentsDocs.isEmpty && _comments.isNotEmpty) {
        isReachedToTheEnd = true;
      }

      emit(CommentsLoaded(_comments));
    } catch (e) {
      emit(CommentsError(e.toString()));
    }
  }

  Future<CommentModel> _getCommentResponse(Map<String, dynamic> data) async {
    CommentModel comment = CommentModel.fromJson(data);
    final userData = await dataRepository.getUserDetails(comment.publisherId);
    UserModel user =
        UserModel.fromJson(userData.data() as Map<String, dynamic>);
    comment.owner = user;
    return comment;
  }

  FutureOr<void> _onAddCommentStarted(
      AddCommentStarted event, Emitter<PostItemState> state) async {
    try {
      emit(AddingComment(event.comment.commentId!));
      comments.insert(0, event.comment);
      await dataRepository.addComment(event.comment);
      emit(CommentAdded());
    } catch (e) {
      print(e.toString());
    }
  }

  _onListenForPostUpdatesStarted(
      ListenForPostUpdatesStarted event, Emitter<PostItemState> state) {
    postsBloc.stream.listen((postState) {
      if (!isClosed) {
        if (postState is PostAdded) {
          if (postState.post.postId == currentPost!.postId) {
            currentPost = postState.post;
            emit(PostStateChanged());
          }
        }
      }
    });
  }

  _onFetchPostDetailsStarted(
      FetchPostDetailsStarted event, Emitter<PostItemState> state) async {
    try {
      emit(PostLoading());
      PostModel? postResponse;

      postResponse = postsBloc.getPost(event.postId);

      if (postResponse == null) {
        final postData =
            await dataRepository.getPostDetails(postId: event.postId);

        if (postData != null) {
          currentPost = await initializePost(
              postData.data() as Map<String, dynamic>, dataRepository);
          // likesBloc.add(AddPostLikesInfoStarted(
          //     id: postResponse.postId,
          //     likes: postResponse.likesCount,
          //     isLiked: isLiked));
        }
      }

      currentPost = postResponse!;
      emit(PostLoaded(postResponse));
    } catch (e) {
      print(e.toString());
      emit(PostItemError(e.toString()));
    }
  }

  Future<void> _onEditPostCaptionStarted(
      PostEditStarted event, Emitter<PostItemState> emit) async {
    try {
      emit(EditingPostCaption());
      await dataRepository.editPostCaption(
          value: event.value, postId: event.postId);
      currentPost!.caption = event.value;
      postsBloc.add(UpdatePostStarted(currentPost!));
      emit(PostCaptionEdited(event.value));
    } catch (e) {
      print(e.toString());
      emit(EditPostCaptionError(e.toString()));
    }
  }



  List<CommentModel> get comments => _comments;
}
