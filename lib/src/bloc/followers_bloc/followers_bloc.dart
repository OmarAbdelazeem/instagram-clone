import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/core/utils/initialize_user.dart';
import 'package:meta/meta.dart';

import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';

part 'followers_event.dart';

part 'followers_state.dart';

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  final DataRepository _dataRepository;
  final UsersBloc _usersBloc;
  final String userId;

  FollowersBloc(this._dataRepository, this._usersBloc, this.userId)
      : super(FollowersInitial()) {
    on<FetchFollowersStarted>(_onFetchFollowersStarted);
  }

  bool isFollowersReachedToTheEnd = false;
  QueryDocumentSnapshot? lastDocument;
  List<UserModel> followersUsers = [];

  _onFetchFollowersStarted(
      FetchFollowersStarted event, Emitter<FollowersState> state) async {
    try {
      List<QueryDocumentSnapshot> followersDocs = [];

      if (!event.nextList) {
        emit(FollowersFirstLoading());
        followersUsers = [];
        isFollowersReachedToTheEnd = false;
        followersDocs =
            (await _dataRepository.getFollowersIds(userId: userId)).docs;
      } else {
        emit(FollowersNextLoading());
        followersDocs = (await _dataRepository.getFollowersIds(
                userId: userId, documentSnapshot: lastDocument))
            .docs;
      }

      for (var doc in followersDocs) {
        UserModel? user = await _getUser(doc.id);
        if (user != null) {
          followersUsers.add(user);
          _usersBloc.addUser(user);
        }
      }

      if (followersDocs.isNotEmpty) {
        lastDocument = followersDocs.last;
      } else if (followersDocs.isEmpty && followersUsers.isNotEmpty) {
        isFollowersReachedToTheEnd = true;
      }
      emit(FollowersLoaded(followersUsers));
    } catch (e) {
      print(e.toString());
      emit(FollowersError(e.toString()));
    }
  }

  Future<UserModel?> _getUser(String id) async {
    final userData = await _dataRepository.getUserDetails(id);
    if (userData.exists) {
      UserModel user = await initializeUser(
          userData.data() as Map<String, dynamic>, _dataRepository);
      return user;
    }
  }
}
