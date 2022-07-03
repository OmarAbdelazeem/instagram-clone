// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModelRequest _$PostModelRequestFromJson(Map<String, dynamic> json) =>
    PostModelRequest(
      caption: json['caption'] as String,
      photoUrl: json['photoUrl'] as String,
      postId: json['postId'] as String,
      commentsCount: json['commentsCount'] as int,
      publisherId: json['publisherId'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      likesCount: json['likesCount'] as int,
    );

Map<String, dynamic> _$PostModelRequestToJson(PostModelRequest instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'photoUrl': instance.photoUrl,
      'postId': instance.postId,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'publisherId': instance.publisherId,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
