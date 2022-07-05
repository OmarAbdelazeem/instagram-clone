import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/likes_info_model/likes_info_model.dart';
import 'package:meta/meta.dart';

part 'likes_event.dart';

part 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  LikesBloc() : super(LikesInitial()) {
    on<AddPostLikesInfoStarted>(_onAddPostLikesInfoStarted);
    on<EditPostCaptionStarted>(_onEditPostCaptionStarted);
  }

  Map<String, Map<String, dynamic>> _postsChangesInfo = {};
  Map<String, dynamic> _postsCaptions = {};

  //add caption to map info

  FutureOr<void> _onAddPostLikesInfoStarted(
      AddPostLikesInfoStarted event, Emitter<LikesState> state) {
    if (!_postsChangesInfo.containsKey(event.id)) {
      _postsChangesInfo.putIfAbsent(
          event.id, () => {"likes": event.likes, "isLiked": event.isLiked});
    } else {
      _postsChangesInfo.update(event.id,
          (value) => {"likes": event.likes, "isLiked": event.isLiked});
    }
    emit(LikesChanged(event.id));
  }

  PostUpdates? getPostUpdatesInfo(String postId) {
    return PostUpdates.fromMap(_postsChangesInfo[postId]!);
  }

  FutureOr<void> _onEditPostCaptionStarted(
      EditPostCaptionStarted event, Emitter<LikesState> state) {
    if (!_postsChangesInfo.containsKey(event.id)) {
      _postsCaptions.putIfAbsent(event.id, () => {"caption": event.caption});
    } else {
      _postsChangesInfo.update(event.id, (value) => {"caption": event.caption});
    }
    emit(CaptionChanged(event.caption));
  }
}
