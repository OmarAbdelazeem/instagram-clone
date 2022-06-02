import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'following_event.dart';

part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  FollowingBloc() : super(FollowingInitial()) {
    on<AddFollowerIdStarted>(_onAddFollowStarted);
    on<RemoveFollowerIdStarted>(_onRemoveFollowStarted);
  }

  Set<String> _followingUsersIds = Set();

  FutureOr<void> _onAddFollowStarted(
      AddFollowerIdStarted event, Emitter<FollowingState> state) {
    _followingUsersIds.add(event.id);
    emit(FollowingChange(event.id));
  }

  FutureOr<void> _onRemoveFollowStarted(
      RemoveFollowerIdStarted event, Emitter<FollowingState> state) {
    _followingUsersIds.remove(event.id);
    emit(FollowingChange(event.id));
  }

  String? getFollowerId(String postId) {
    var result = _followingUsersIds.where((element) => element == postId);
    if(result.isNotEmpty)
    return result.first;
  }
}
