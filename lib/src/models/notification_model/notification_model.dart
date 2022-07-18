import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String userId;
  final String type;
  final String? postId;
  @JsonKey(ignore: true)
  UserModel? user;
  @JsonKey(ignore: true)
  PostModel? post;
  @TimestampConverter()
  final DateTime timestamp;

  NotificationModel({
    required this.userId,
    required this.timestamp,
    this.post,
    this.user,
    required this.type,
    required this.postId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
