// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class PostModel {
//   String caption;
//   String name;
//   String photoUrl;
//   String postId;
//   List postLikes;
//   String ownerId;
//   String ownerProfilePhoto;
//   Timestamp timestamp;

//
//   PostModel(
//       {required this.name,
//         required this.caption,
//         required this.photoUrl,
//         required this.postId,
//         required this.ownerId,
//         required this.timestamp,
//         required this.postLikes,
//         required this.ownerProfilePhoto});
//
//   factory PostModel.fromDocument(DocumentSnapshot doc) {
//     return PostModel(
//         caption: doc['caption'],
//         name: doc['name'],
//         postLikes: doc['likes'],
//         photoUrl: doc['photoUrl'],
//         postId: doc['postId'],
//         ownerId: doc['publisherId'],
//         timestamp: doc['timestamp'],
//         ownerProfilePhoto: doc['publisherProfilePhoto']
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  String caption;
  String name;
  String photoUrl;
  String postId;
  List postLikes;
  String ownerId;
  String ownerProfilePhoto;
  String timestamp;

  PostModel(
      {required this.name,
      required this.caption,
      required this.photoUrl,
      required this.postId,
      required this.ownerId,
      required this.timestamp,
      required this.postLikes,
      required this.ownerProfilePhoto});

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
