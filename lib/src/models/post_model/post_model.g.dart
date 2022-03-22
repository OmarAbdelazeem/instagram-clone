// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      name: json['name'] as String,
      caption: json['caption'] as String,
      photoUrl: json['photoUrl'] as String,
      postId: json['postId'] as String,
      ownerId: json['ownerId'] as String,
      timestamp: json['timestamp'] as String,
      postLikes: json['postLikes'] as List<dynamic>,
      ownerProfilePhoto: json['ownerProfilePhoto'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'caption': instance.caption,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'postId': instance.postId,
      'postLikes': instance.postLikes,
      'ownerId': instance.ownerId,
      'ownerProfilePhoto': instance.ownerProfilePhoto,
      'timestamp': instance.timestamp,
    };
