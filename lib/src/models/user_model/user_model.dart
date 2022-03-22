
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel{
  String bio;
  String id;
  String userName;
  String photoUrl;
  String email;
  int followingCount;
  int followersCount;
  int postsCount;
  String timestamp;

  UserModel({
   required this.photoUrl,
    required this.userName,
    required this.bio,
    required this.id,
    required this.email,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.timestamp
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
