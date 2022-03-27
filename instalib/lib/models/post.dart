import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String caption;
  String name;
  String photoUrl;
  String postId;
  List postLikes;
  String publisherId;
  String publisherProfilePhotoUrl;
  Timestamp timestamp;

  Post(
      {this.name,
        this.caption,
        this.photoUrl,
        this.postId,
        this.publisherId,
        this.timestamp,
        this.postLikes,
        this.publisherProfilePhotoUrl});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
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
