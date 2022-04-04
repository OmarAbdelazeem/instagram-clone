// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      publisherName: json['publisherName'] as String,
      caption: json['caption'] as String,
      photoUrl: json['photoUrl'] as String,
      commentsCount: json["commentsCount"],
      postId: json['postId'] as String,
      publisherId: json['publisherId'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      likesCount: json['likesCount'] as int,
      publisherProfilePhotoUrl: json['publisherProfilePhotoUrl'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'caption': instance.caption,
      'publisherName': instance.publisherName,
      'photoUrl': instance.photoUrl,
      'postId': instance.postId,
      "commentsCount": instance.commentsCount,
      'likesCount': instance.likesCount,
      'publisherId': instance.publisherId,
      'publisherProfilePhotoUrl': instance.publisherProfilePhotoUrl,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
