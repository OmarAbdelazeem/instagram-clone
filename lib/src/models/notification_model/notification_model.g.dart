// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      postUrl: json['postUrl'] as String,
      senderId: json['senderId'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      comment: json['comment'] as String,
      notificationTypeNum: json['notificationTypeNum'] as int,
      postId: json['postId'] as String,
      ownerName: json['ownerName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'postUrl': instance.postUrl,
      'notificationTypeNum': instance.notificationTypeNum,
      'ownerName': instance.ownerName,
      'comment': instance.comment,
      'postId': instance.postId,
      'userPhotoUrl': instance.userPhotoUrl,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
