import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/likes_info_model/likes_info_model.dart';
import 'package:meta/meta.dart';

part 'likes_event.dart';

part 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  LikesBloc() : super(LikesInitial()) {
    on<AddPostLikesInfoStarted>(_onAddPostLikesInfoStarted);
  }

  Map<String, Map<String, dynamic>> _postsLikesInfo = {};

  FutureOr<void> _onAddPostLikesInfoStarted(
      AddPostLikesInfoStarted event, Emitter<LikesState> state) {
    if (!_postsLikesInfo.containsKey(event.id)) {
      _postsLikesInfo.putIfAbsent(
          event.id, () => {"likes": event.likes, "isLiked": event.isLiked});
    } else {
      _postsLikesInfo.update(event.id,
          (value) => {"likes": event.likes, "isLiked": event.isLiked});
    }
    emit(LikesChanged(event.id));
  }

  LikesInfo? getPostLikesInfo(String postId) {
    return LikesInfo.fromMap(_postsLikesInfo[postId]!);
  }
}
