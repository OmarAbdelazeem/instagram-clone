import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model_response/comment_model_response.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';

part 'comment_model_request.g.dart';

@JsonSerializable()
class CommentModelRequest {
  final String publisherId;
  final String postPhotoUrl;
  final String comment;
  final String postId;
  final String postPublisherId;
  String? commentId;
  @TimestampConverter()
  final DateTime timestamp;

  CommentModelRequest({
    required this.comment,
    required this.publisherId,
    required this.commentId,
    required this.postId,
    required this.postPublisherId,
    required this.postPhotoUrl,
    required this.timestamp,
  });

  factory CommentModelRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentModelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelRequestToJson(this);

  factory CommentModelRequest.fromCommentResponse(CommentModelResponse commentResponse){
    return CommentModelRequest(
      postPublisherId: commentResponse.postPublisherId,
      timestamp: commentResponse.timestamp,
      publisherId: commentResponse.publisherId,
      postId: commentResponse.postId,
      comment: commentResponse.comment,
      commentId: commentResponse.commentId,
      postPhotoUrl: commentResponse.postPhotoUrl
    );
  }

}
