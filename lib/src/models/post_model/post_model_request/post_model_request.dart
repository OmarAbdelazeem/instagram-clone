import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/time_stamp_converter.dart';

part 'post_model_request.g.dart';

@JsonSerializable()
class PostModelRequest {
  String caption;
  String photoUrl;
  String postId;
  int likesCount;
  int commentsCount;
  String publisherId;
  @TimestampConverter()
  DateTime? timestamp;

  PostModelRequest({
    required this.caption,
    required this.photoUrl,
    required this.postId,
    required this.commentsCount,
    required this.publisherId,
    required this.timestamp,
    required this.likesCount,
  });

  factory PostModelRequest.fromJson(Map<String, dynamic> json) =>
      _$PostModelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelRequestToJson(this);
}
