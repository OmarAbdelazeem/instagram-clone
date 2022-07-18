// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      caption: json['caption'] as String,
      photoUrl: json['photoUrl'] as String,
      postId: json['postId'] as String,
      isLiked: json['isLiked'] as bool?,
      commentsCount: json['commentsCount'] as int,
      publisherId: json['publisherId'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      likesCount: json['likesCount'] as int,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'caption': instance.caption,
      'photoUrl': instance.photoUrl,
      'postId': instance.postId,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'publisherId': instance.publisherId,
      'isLiked': instance.isLiked,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
