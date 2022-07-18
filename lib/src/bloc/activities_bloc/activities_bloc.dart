import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagramapp/src/core/utils/initialize_notification.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';

import '../../models/notification_model/notification_model.dart';
import '../../repository/data_repository.dart';
import '../users_bloc/users_bloc.dart';

part 'activities_event.dart';

part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final DataRepository _dataRepository;
  final UsersBloc _usersBloc;

  ActivitiesBloc(this._dataRepository, this._usersBloc)
      : super(ActivitiesInitial()) {
    on<FetchActivitiesStarted>(_onFetchActivitiesStarted);
  }

  List<NotificationModel> _activities = [];
  QueryDocumentSnapshot? lastDocument;
  bool isReachedToTheEnd = false;

  Future<void> _onFetchActivitiesStarted(
      FetchActivitiesStarted event, Emitter<ActivitiesState> state) async {
    try {
      List<QueryDocumentSnapshot> activitiesRequestsDocs = [];
      if (!event.nextList) {
        emit(FirstActivitiesLoading());
        _activities = [];
        isReachedToTheEnd = false;
        activitiesRequestsDocs =
            (await _dataRepository.getNotifications()).docs;
      } else {
        emit(NextActivitiesLoading());
        activitiesRequestsDocs = (await _dataRepository.getNotifications(
                documentSnapshot: lastDocument))
            .docs;
      }

      for (var doc in activitiesRequestsDocs) {
        final activity = await initializeActivity(
            doc.data() as Map<String, dynamic>, _dataRepository);
        _activities.add(activity);
        _usersBloc.addUser(activity.user!);
      }

      if (activitiesRequestsDocs.isNotEmpty) {
        lastDocument = activitiesRequestsDocs.last;
      } else if (activitiesRequestsDocs.isEmpty && _activities.isNotEmpty) {
        isReachedToTheEnd = true;
      }

      emit(ActivitiesLoaded(_activities));
    } catch (e) {}
  }

  List<NotificationModel> get activities => _activities;
}
