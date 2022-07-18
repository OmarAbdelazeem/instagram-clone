import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String caption;
  String photoUrl;
  String postId;
  int likesCount;
  int commentsCount;
  String publisherId;
  @JsonKey(ignore: true)
  UserModel? owner;
   bool? isLiked;
  @TimestampConverter()
  DateTime? timestamp;

  PostModel({
    required this.caption,
    required this.photoUrl,
    required this.postId,
    this.owner,
    this.isLiked,
    required this.commentsCount,
    required this.publisherId,
    required this.timestamp,
    required this.likesCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
