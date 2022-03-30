// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      photoUrl: json['photoUrl'] as String,
      userName: json['userName'] as String,
      bio: json['bio'] as String,
      id: json['id'] as String,
      email: json['email'] as String,
      postsCount: json['postsCount'] as int,
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
      timestamp:
          const TimestampConverter().fromJson(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'bio': instance.bio,
      'id': instance.id,
      'userName': instance.userName,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'followingCount': instance.followingCount,
      'followersCount': instance.followersCount,
      'postsCount': instance.postsCount,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
    };
