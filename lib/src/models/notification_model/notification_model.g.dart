// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      postUrl: json['postUrl'] as String,
      ownerId: json['ownerId'] as String,
      timestamp: json['timestamp'] as String,
      comment: json['comment'] as String,
      postId: json['postId'] as String,
      ownerName: json['ownerName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'postUrl': instance.postUrl,
      'timestamp': instance.timestamp,
      'ownerName': instance.ownerName,
      'comment': instance.comment,
      'postId': instance.postId,
      'userPhotoUrl': instance.userPhotoUrl,
    };
