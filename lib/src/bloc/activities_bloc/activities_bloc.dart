import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/notification_model/notification_request_model/notification_request_model.dart';
import 'package:instagramapp/src/models/notification_model/notification_response_model/notification_response_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';

import '../../repository/data_repository.dart';

part 'activities_event.dart';

part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final DataRepository _dataRepository;

  ActivitiesBloc(this._dataRepository) : super(ActivitiesInitial()) {
    on<FetchActivitiesStarted>(_onFetchActivitiesStarted);
  }

  List<NotificationResponseModel> notifications = [];

  Future<void> _onFetchActivitiesStarted(FetchActivitiesStarted event,
      Emitter<ActivitiesState> state) async {
    try {
      notifications = [];
      emit(ActivitiesLoading());
      final notificationRequestsDocs =
          (await _dataRepository.getNotifications()).docs;
      for (var doc in notificationRequestsDocs) {
        final NotificationRequestModel notificationRequest =
        NotificationRequestModel.fromJson(
            doc.data() as Map<String, dynamic>);
        final userData =
        await _dataRepository.getUserDetails(notificationRequest.userId);
        final user =
        UserModel.fromJson(userData.data() as Map<String, dynamic>);
        NotificationResponseModel notificationResponse = NotificationResponseModel
            .fromUserAndNotificationRequest(user, notificationRequest);
        notifications.add(notificationResponse);
      }

      emit(ActivitiesLoaded(notifications));
    } catch (e) {}
  }
}
