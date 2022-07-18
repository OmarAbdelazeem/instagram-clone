import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/utils/initialize_user.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';
import '../users_bloc/users_bloc.dart';

part 'following_event.dart';

part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final DataRepository _dataRepository;
  final UsersBloc _usersBloc;
  final String userId;

  FollowingBloc(this._dataRepository, this._usersBloc, this.userId) : super(FollowingInitial()) {
    on<FetchFollowingUsersStarted>(_onFetchFollowingStarted);
  }

  List<UserModel> followingUsers = [];
  QueryDocumentSnapshot? lastFollowingDocument;
  bool isFollowingReachedToTheEnd = false;

  _onFetchFollowingStarted(
      FetchFollowingUsersStarted event, Emitter<FollowingState> state) async {
    try {
      List<QueryDocumentSnapshot> followingDocs = [];

      if (!event.nextList) {
        emit(FollowingFirstLoading());
        followingUsers = [];
        isFollowingReachedToTheEnd = false;
        followingDocs =
            (await _dataRepository.getFollowingIds(userId: userId)).docs;
      } else {
        emit(FollowingNextLoading());
        followingDocs = (await _dataRepository.getFollowingIds(
                userId: userId, documentSnapshot: lastFollowingDocument))
            .docs;
      }

      for (var doc in followingDocs) {
        UserModel? user = await _getUser(doc.id);
        if (user != null){
          followingUsers.add(user);
          _usersBloc.addUser(user);
        }
      }

      if (followingDocs.isNotEmpty) {
        lastFollowingDocument = followingDocs.last;
      } else if (followingDocs.isEmpty && followingUsers.isNotEmpty) {
        isFollowingReachedToTheEnd = true;
      }
      emit(FollowingLoaded(followingUsers));
    } catch (e) {
      print(e.toString());
      emit(FollowingError(e.toString()));
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
