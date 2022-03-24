import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class PostModel {
  String caption;
  String publisherName;
  String photoUrl;
  String postId;
  int likesCount;
  String publisherId;
  String publisherProfilePhotoUrl;
  @TimestampConverter()
  DateTime timestamp;

  PostModel(
      {required this.publisherName,
      required this.caption,
      required this.photoUrl,
      required this.postId,
      required this.publisherId,
      required this.timestamp,
      required this.likesCount,
      required this.publisherProfilePhotoUrl});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
