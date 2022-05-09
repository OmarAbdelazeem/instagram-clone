// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      caption: json['caption'] as String,
      photoUrl: json['photoUrl'] as String,
      postId: json['postId'] as String,
      publisherName: json['publisherName'] as String,
      publisherProfilePhotoUrl: json['publisherProfilePhotoUrl'] as String,
      commentsCount: json['commentsCount'] as int,
      publisherId: json['publisherId'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      likesCount: json['likesCount'] as int,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'caption': instance.caption,
      'photoUrl': instance.photoUrl,
      'postId': instance.postId,
      'publisherName': instance.publisherName,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'publisherProfilePhotoUrl': instance.publisherProfilePhotoUrl,
      'publisherId': instance.publisherId,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
