import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/post_model/post_model_request/post_model_request.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';

class PostModelResponse {
  String caption;
  String photoUrl;
  String postId;
  String publisherName;
  int likesCount;
  int commentsCount;
  String publisherProfilePhotoUrl;
  String publisherId;
  DateTime timestamp;

  PostModelResponse({
    required this.caption,
    required this.photoUrl,
    required this.postId,
    required this.publisherName,
    required this.publisherProfilePhotoUrl,
    required this.commentsCount,
    required this.publisherId,
    required this.timestamp,
    required this.likesCount,
  });

  factory PostModelResponse.getDataFromPostRequestAndUser(
      PostModelRequest postRequest, UserModel user) {
    return PostModelResponse(
        caption: postRequest.caption,
        commentsCount: postRequest.commentsCount,
        likesCount: postRequest.likesCount,
        photoUrl: postRequest.photoUrl,
        postId: postRequest.postId,
        publisherId: postRequest.publisherId,
        timestamp: postRequest.timestamp!,
        publisherName: user.userName!,
        publisherProfilePhotoUrl: user.photoUrl!);
  }
}
