import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';

import '../../repository/data_repository.dart';

part 'follow_event.dart';

part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final DataRepository _dataRepository;

  FollowBloc(this._dataRepository) : super(FollowInitial()) {
    on<FollowEventStarted>(_onFollowStarted);
    on<UnFollowEventStarted>(_onUnFollowStarted);
    on<CheckUserFollowingStateStarted>(_onCheckUserFollowingStateStarted);
  }

  void _onFollowStarted(
      FollowEventStarted event, Emitter<FollowState> state) async {
    try {
      await _dataRepository.addFollower(
          receiverId: event.receiverUser.id, senderId: event.senderId);
      final user = event.receiverUser;
      user.followersCount++;
      emit(UserFollowed(user));
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowEventStarted event, Emitter<FollowState> state) async {
    try {
      await _dataRepository.removeFollower(
          receiverId: event.receiverUser.id, senderId: event.senderId);
      final user = event.receiverUser;
      user.followersCount--;
      emit(UserUnFollowed(user));
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  void _onCheckUserFollowingStateStarted(
      CheckUserFollowingStateStarted event, Emitter<FollowState> state) async{
    try {
      final isFollowing = await _dataRepository.checkIfUserFollowingSomeOne(
          senderId: event.senderId, receiverId: event.receiverId);
      if(isFollowing){
        emit(UserFollowed());
      }else
        emit(UserUnFollowed());
    } catch (e) {}
  }
}
