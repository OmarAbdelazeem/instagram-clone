import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()

class NotificationModel {
  final String ownerId;
  final String postUrl;
  final int notificationTypeNum;
  final String timestamp;
  final String ownerName;
  final String comment;
  final String postId;
  final String userPhotoUrl;

  NotificationModel(
      {required this.postUrl,
      required this.ownerId,
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
