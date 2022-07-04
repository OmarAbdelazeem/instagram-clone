// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRequestModel _$NotificationRequestModelFromJson(
        Map<String, dynamic> json) =>
    NotificationRequestModel(
      userId: json['userId'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      type: json['type'] as String,
      postPhotoUrl: json['postPhotoUrl'] as String?,
      postId: json['postId'] as String?,
    );

Map<String, dynamic> _$NotificationRequestModelToJson(
        NotificationRequestModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'type': instance.type,
      'postPhotoUrl': instance.postPhotoUrl,
      'postId': instance.postId,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
