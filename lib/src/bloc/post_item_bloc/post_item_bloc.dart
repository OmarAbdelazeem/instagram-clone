import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:meta/meta.dart';

part 'post_item_event.dart';

part 'post_item_state.dart';

class PostItemBloc extends Bloc<PostItemEvent, PostItemState> {
  final DataRepository _dataRepository;

  PostItemBloc(this._dataRepository) : super(PostItemInitial()) {
    on<ListenToPostStarted>(_onListenToPostStarted);
    on<AddLikeStarted>(_onAddLikeStarted);
    on<RemoveLikeStarted>(_onRemoveLikeStarted);
    on<LoadCommentsStarted>(_onLoadCommentsStarted);
    on<AddCommentStarted>(_onAddCommentStarted);
  }

  PostModel? currentPost;
  List<CommentModel> comments = [];

  FutureOr<void> _onListenToPostStarted(
      ListenToPostStarted event, Emitter<PostItemState> state) {
    emit(PostLoading());
    try {
      _dataRepository.listenToPostDetails(postId: event.postId).listen((event) {
        if (event.data() != null) {
          currentPost =
              PostModel.fromJson(event.data() as Map<String, dynamic>);
          emit(PostLoaded(currentPost!));
        }
      });
    } catch (e) {}
  }

  FutureOr<void> _onAddLikeStarted(
      AddLikeStarted event, Emitter<PostItemState> state) {
    try {
      emit(PostIsLiked());
      _dataRepository.addLikeToPost(postId: event.postId, userId: event.userId);
    } catch (e) {
      print(e.toString());
    }
  }

  FutureOr<void> _onRemoveLikeStarted(
      RemoveLikeStarted event, Emitter<PostItemState> state) {
    try {
      emit(PostIsUnLiked());
      _dataRepository.removeLikeFromPost(
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
}
