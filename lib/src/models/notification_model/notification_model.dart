import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String senderId;
  final String postUrl;
  final int notificationTypeNum;
  final String ownerName;
  final String comment;
  final String postId;
  final String userPhotoUrl;
  @TimestampConverter()
  final DateTime timestamp;

  NotificationModel(
      {required this.postUrl,
      required this.senderId,
      required this.timestamp,
      required this.comment,
      required this.notificationTypeNum,
      required this.postId,
      required this.ownerName,
      required this.userPhotoUrl});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
