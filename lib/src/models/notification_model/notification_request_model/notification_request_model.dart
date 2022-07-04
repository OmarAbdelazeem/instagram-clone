import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';

part 'notification_request_model.g.dart';

@JsonSerializable()
class NotificationRequestModel {
  final String userId;
  final String type;
  final String? postPhotoUrl;
  final String? postId;
  @TimestampConverter()
  final DateTime timestamp;

  NotificationRequestModel({
    required this.userId,
    required this.timestamp,
    required this.type,
    required this.postPhotoUrl,
    required this.postId,
  });

  factory NotificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationRequestModelToJson(this);
}
