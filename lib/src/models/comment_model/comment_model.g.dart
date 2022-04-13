// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      comment: json['comment'] as String,
      publisherId: json['publisherId'] as String,
      publisherName: json['publisherName'] as String,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String,
      postUrl: json['postUrl'] as String,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
      publisherPhotoUrl: json['publisherPhotoUrl'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'publisherId': instance.publisherId,
      'postUrl': instance.postUrl,
      'comment': instance.comment,
      'publisherName': instance.publisherName,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'publisherPhotoUrl': instance.publisherPhotoUrl,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
