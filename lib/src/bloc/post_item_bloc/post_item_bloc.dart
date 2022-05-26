import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';
import '../../core/saved_posts_likes.dart';

part 'post_item_event.dart';

part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;
  final OfflineLikesRepository _offlineLikesRepo;

  PostItemBloc(this._dataRepository, this._offlineLikesRepo, this._likesBloc)
      : super(PostItemInitial()) {
    on<ListenToPostStarted>(_onListenToPostStarted);
    on<AddLikeStarted>(_onAddLikeStarted);
    on<RemoveLikeStarted>(_onRemoveLikeStarted);
    on<LoadCommentsStarted>(_onLoadCommentsStarted);
    on<AddCommentStarted>(_onAddCommentStarted);
    on<CheckIfPostIsLikedStarted>(_onCheckIfPostIsLikedStarted);
  }

  PostModel? _currentPost;
  List<CommentModel> comments = [];
  bool _isLiked = false;

  // int _likesCount = 0;

  FutureOr<void> _onListenToPostStarted(
      ListenToPostStarted event, Emitter<PostItemState> state) {
    emit(PostLoading());
    try {
      _dataRepository.listenToPostDetails(postId: event.postId).listen((event) {
        if (event.data() != null) {
          _currentPost =
              PostModel.fromJson(event.data() as Map<String, dynamic>);
          emit(PostLoaded(_currentPost!));
        }
      });
    } catch (e) {}
  }

  FutureOr<void> _onAddLikeStarted(
      AddLikeStarted event, Emitter<PostItemState> state) async {
    try {
      _likesBloc.add(AddPostLikesInfoStarted(isLiked: true , id: "1",likes: 7));
      emit(PostIsLiked());
      _isLiked = true;
      _currentPost!.likesCount++;
      _offlineLikesRepo.addPostLikesInfo(
          id: currentPost.postId, likes: currentPost.likesCount, isLiked: true);
      await _dataRepository.addLikeToPost(
          postId: event.postId, userId: event.userId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onRemoveLikeStarted(
      RemoveLikeStarted event, Emitter<PostItemState> state) async {
    try {
      _likesBloc.add(AddPostLikesInfoStarted(isLiked: true , id: "2",likes: 7));
      emit(PostIsUnLiked());
      _isLiked = false;
      _currentPost!.likesCount--;
      _offlineLikesRepo.addPostLikesInfo(
          id: currentPost.postId,
          likes: currentPost.likesCount,
          isLiked: false);
      await _dataRepository.removeLikeFromPost(
          postId: event.postId, publisherId: event.userId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onLoadCommentsStarted(
      LoadCommentsStarted event, Emitter<PostItemState> state) async {
    try {
      emit(CommentsLoading());
      final commentsData = await _dataRepository.getPostComments(event.postId);
      comments = commentsData.docs
          .map((e) => CommentModel.fromJson(e.data()))
          .toList();
      emit(CommentsLoaded(comments));
    } catch (e) {}
  }

  FutureOr<void> _onAddCommentStarted(
      AddCommentStarted event, Emitter<PostItemState> state) async {
    try {
      emit(AddingComment(event.comment.commentId!));
      comments.add(event.comment);
      await Future.delayed(Duration(seconds: 3));
      await _dataRepository.addComment(event.comment);
      emit(CommentAdded());
    } catch (e) {
      print(e.toString());
    }
  }

  _onCheckIfPostIsLikedStarted(
      CheckIfPostIsLikedStarted event, Emitter<PostItemState> state) {
    _likesBloc.stream.listen((likesState) {
      if (likesState is LikesChanged) {
        print("change is ${likesState.postId}");
      }
    });

    // _offlineLikesRepo.listenToLikesInfo(_currentPost!.postId).listen((result) {
    //   print("result is $result");
    //   _currentPost!.likesCount = result!["likes"];
    //   _isLiked = result["isLiked"];
    //   if (_isLiked) {
    //     emit(PostIsLiked());
    //   } else {
    //     emit(PostIsUnLiked());
    //   }
    // });

    // Map<String, dynamic>? result =
    //     _offlineLikesRepo.getPostLikesInfo(_currentPost!.postId);
    // print("result is $result");
    // _currentPost!.likesCount = result!["likes"];
    // _isLiked = result["isLiked"];
    // if (_isLiked) {
    //   emit(PostIsLiked());
    // } else {
    //   emit(PostIsUnLiked());
    // }
  }

  bool get isLiked => _isLiked;

  PostModel get currentPost => _currentPost!;

  void setCurrentPost(PostModel post) {
    _currentPost = post;
  }
}
