// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      comment: json['comment'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      postId: json['postId'] as String,
      postUrl: json['postUrl'] as String,
      timestamp: json['timestamp'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'timestamp': instance.timestamp,
      'postUrl': instance.postUrl,
      'comment': instance.comment,
      'ownerName': instance.ownerName,
      'postId': instance.postId,
      'userPhotoUrl': instance.userPhotoUrl,
    };
