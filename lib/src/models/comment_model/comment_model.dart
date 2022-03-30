import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String ownerId;
  final String postUrl;
  final String comment;
  final String ownerName;

  final String postId;
  final String userPhotoUrl;
  @TimestampConverter()
  final DateTime timestamp;

  CommentModel(
      {required this.comment,
      required this.ownerId,
      required this.ownerName,
      required this.postId,
      required this.postUrl,
      required this.timestamp,
      required this.userPhotoUrl});

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
