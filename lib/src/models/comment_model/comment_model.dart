import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String publisherId;
  final String postUrl;
  final String comment;
  final String publisherName;
  final String postId;
  final String commentId;
  final String publisherPhotoUrl;
  @TimestampConverter()
  final DateTime timestamp;

  CommentModel(
      {required this.comment,
      required this.publisherId,
      required this.publisherName,
      required this.postId,
      required this.commentId,
      required this.postUrl,
      required this.timestamp,
      required this.publisherPhotoUrl});

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
