import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';
import '../notification_request_model/notification_request_model.dart';

part 'notification_response_model.g.dart';

@JsonSerializable()
class NotificationResponseModel {
  final String userId;
  final String? postPhotoUrl;
  final String type;
  final String userName;
  final String? postId;
  final String? userPhotoUrl;
  @TimestampConverter()
  final DateTime timestamp;

  NotificationResponseModel(
      {required this.postPhotoUrl,
      required this.userId,
      required this.timestamp,
      required this.type,
      required this.postId,
      required this.userName,
      required this.userPhotoUrl});

  factory NotificationResponseModel.fromUserAndNotificationRequest(
      UserModel user, NotificationRequestModel notificationRequest) {
    return NotificationResponseModel(
        postPhotoUrl: notificationRequest.postPhotoUrl,
        userId: user.id!,
        timestamp: notificationRequest.timestamp,
        type: notificationRequest.type,
        postId: notificationRequest.postId,
        userName: user.userName!,
        userPhotoUrl: user.photoUrl!);
  }
}
