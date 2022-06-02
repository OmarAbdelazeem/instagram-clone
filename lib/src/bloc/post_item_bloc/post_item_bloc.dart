import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/bloc/likes_bloc/likes_bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/likes_info_model/likes_info_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';
import '../../core/saved_posts_likes.dart';

part 'post_item_event.dart';

part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  final DataRepository _dataRepository;
  final LikesBloc _likesBloc;
  final PostModel _currentPost;

  PostItemBloc(this._dataRepository, this._likesBloc, this._currentPost)
      : super(PostItemInitial()) {
    on<AddLikeStarted>(_onAddLikeStarted);
    on<RemoveLikeStarted>(_onRemoveLikeStarted);
    on<LoadCommentsStarted>(_onLoadCommentsStarted);
    on<AddCommentStarted>(_onAddCommentStarted);
    on<CheckIfPostIsLikedStarted>(_onCheckIfPostIsLikedStarted);
  }

  List<CommentModel> comments = [];
  bool _isLiked = false;

  FutureOr<void> _onAddLikeStarted(
      AddLikeStarted event, Emitter<PostItemState> state) async {
    try {
      emit(PostIsLiked());
      _isLiked = true;
      _currentPost.likesCount++;
      _likesBloc.add(AddPostLikesInfoStarted(
          isLiked: true,
          id: _currentPost.postId,
          likes: _currentPost.likesCount));

      await _dataRepository.addLikeToPost(
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
      _currentPost.likesCount--;
      _likesBloc.add(AddPostLikesInfoStarted(
          isLiked: false,
          id: _currentPost.postId,
          likes: _currentPost.likesCount));

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
      await _dataRepository.addComment(event.comment);
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
    _likesBloc.stream.listen((likesState) {
      if (likesState is LikesChanged) {
        LikesInfo likesInfo = _likesBloc.getPostLikesInfo(currentPost.postId)!;
        _isLiked = likesInfo.isLiked;
        _currentPost.likesCount = likesInfo.likes;
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

  void getInitialValueOfLikes() {
    LikesInfo likesInfo = _likesBloc.getPostLikesInfo(_currentPost.postId)!;
    _isLiked = likesInfo.isLiked;
    _currentPost.likesCount = likesInfo.likes;
    if (_isLiked) {
      emit(PostIsLiked());
    } else {
      emit(PostIsUnLiked());
    }
  }

  bool get isLiked => _isLiked;

  PostModel get currentPost => _currentPost;
}
