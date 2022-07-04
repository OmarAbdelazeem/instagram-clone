// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModelRequest _$CommentModelRequestFromJson(Map<String, dynamic> json) =>
    CommentModelRequest(
      comment: json['comment'] as String,
      publisherId: json['publisherId'] as String,
      commentId: json['commentId'] as String?,
      postId: json['postId'] as String,
      postPublisherId: json['postPublisherId'] as String,
      postPhotoUrl: json['postPhotoUrl'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$CommentModelRequestToJson(
        CommentModelRequest instance) =>
    <String, dynamic>{
      'publisherId': instance.publisherId,
      'postPhotoUrl': instance.postPhotoUrl,
      'comment': instance.comment,
      'postId': instance.postId,
      'postPublisherId': instance.postPublisherId,
      'commentId': instance.commentId,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
