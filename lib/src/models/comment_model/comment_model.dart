import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';
import '../user_model/user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String publisherId;
  final String postPhotoUrl;
  final String comment;
  final String postId;
  final String postPublisherId;
  String? commentId;
  @JsonKey(ignore: true)
  UserModel? owner;
  @TimestampConverter()
  final DateTime timestamp;

  CommentModel({
    required this.comment,
    required this.publisherId,
    required this.commentId,
    required this.postId,
    this.owner,
    required this.postPublisherId,
    required this.postPhotoUrl,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
