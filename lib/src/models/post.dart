import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String caption;
  String name;
  String photoUrl;
  String postId;
  List postLikes;
  String publisherId;
  String publisherProfilePhotoUrl;
  Timestamp timestamp;

  PostModel(
      {required this.name,
        required this.caption,
        required this.photoUrl,
        required this.postId,
        required this.publisherId,
        required this.timestamp,
        required this.postLikes,
        required this.publisherProfilePhotoUrl});

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
        caption: doc['caption'],
        name: doc['name'],
        postLikes: doc['likes'],
        photoUrl: doc['photoUrl'],
        postId: doc['postId'],
        publisherId: doc['publisherId'],
        timestamp: doc['timestamp'],
        publisherProfilePhotoUrl: doc['publisherProfilePhoto']
    );
  }
}
