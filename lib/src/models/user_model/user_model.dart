import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_stamp_converter.dart';

part 'user_model.g.dart';

@JsonSerializable()
//Todo implement equatable to compare user in listening stream
class UserModel {
  String? bio;
  String? id;
  String? userName;
  String? photoUrl;
  String? email;
  int? followingCount;
  int? followersCount;
  int? postsCount;
  String? token;
  @TimestampConverter()
  DateTime timestamp;

  UserModel(
      {this.photoUrl,
      this.userName,
      this.bio,
      this.id,
      this.email,
      this.postsCount,
        this.token,
      this.followersCount,
      this.followingCount,
     required this.timestamp});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
