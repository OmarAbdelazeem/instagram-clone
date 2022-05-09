import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String caption;
  String photoUrl;
  String postId;
  String publisherName;
  int likesCount;
  int commentsCount;
  String publisherProfilePhotoUrl;
  String publisherId;
  @TimestampConverter()
  DateTime timestamp;

  PostModel({
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

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
