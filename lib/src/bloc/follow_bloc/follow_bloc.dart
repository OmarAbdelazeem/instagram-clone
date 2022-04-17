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
    on<CheckUserFollowingStarted>(_onCheckUserFollowingStateStarted);
  }

  UserModel? _loggedInUser;
  UserModel? _searchedUser;

  void _onFollowStarted(
      FollowEventStarted event, Emitter<FollowState> state) async {
    try {
      emit(UserFollowed());
      await _dataRepository.addFollower(
          receiverId: _searchedUser!.id, senderId: _loggedInUser!.id);
    } catch (e) {
      print(e.toString());
      emit(FollowError(e.toString()));
    }
  }

  void _onUnFollowStarted(
      UnFollowEventStarted event, Emitter<FollowState> state) async {
    try {
      emit(UserUnFollowed());
      await _dataRepository.removeFollower(
          receiverId: _searchedUser!.id, senderId: _loggedInUser!.id);
    } catch (e) {
      print(e.toString());
      emit(FollowError(e.toString()));
    }
  }

  void _onCheckUserFollowingStateStarted(
      CheckUserFollowingStarted event, Emitter<FollowState> state) async {
    try {
      emit(FollowLoading());
      _loggedInUser = event.loggedInUser;
      _searchedUser = event.searchedUser;
      final isFollowing = await _dataRepository.checkIfUserFollowingSearched(
          receiverId: _searchedUser!.id, senderId: _loggedInUser!.id);
      if (isFollowing) {
        emit(UserFollowed());
      } else
        emit(UserUnFollowed());
    } catch (e) {
      emit(UserUnFollowed());
    }
  }
}
