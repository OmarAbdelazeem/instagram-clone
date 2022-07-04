// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponseModel _$NotificationResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationResponseModel(
      postPhotoUrl: json['postPhotoUrl'] as String?,
      userId: json['userId'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      type: json['type'] as String,
      postId: json['postId'] as String?,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
    );

Map<String, dynamic> _$NotificationResponseModelToJson(
        NotificationResponseModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'postPhotoUrl': instance.postPhotoUrl,
      'type': instance.type,
      'userName': instance.userName,
      'postId': instance.postId,
      'userPhotoUrl': instance.userPhotoUrl,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
