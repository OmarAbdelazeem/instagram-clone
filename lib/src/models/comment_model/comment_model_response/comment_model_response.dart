import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model_request/comment_model_request.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';
import '../../user_model/user_model.dart';

class CommentModelResponse {
  final String publisherId;
  final String postUrl;
  final String comment;
  final String publisherName;
  final String postId;
  final String postPublisherId;
  String? commentId;
  final String publisherPhotoUrl;
  final DateTime timestamp;

  CommentModelResponse({required this.comment,
    required this.publisherId,
    required this.commentId,
    required this.publisherName,
    required this.postId,
    required this.postPublisherId,
    required this.postUrl,
    required this.timestamp,
    required this.publisherPhotoUrl});

  factory CommentModelResponse.getDataFromCommentRequestAndUser(
      CommentModelRequest commentRequest, UserModel user) {
    return CommentModelResponse(
      comment: commentRequest.comment,
      postPublisherId: commentRequest.postPublisherId,
      commentId: commentRequest.commentId,
      postUrl: commentRequest.postUrl,
      publisherPhotoUrl: user.photoUrl!,
      postId: commentRequest.postId,
      publisherId: commentRequest.publisherId,
      timestamp: commentRequest.timestamp,
      publisherName: user.userName!,
    );
  }
}
