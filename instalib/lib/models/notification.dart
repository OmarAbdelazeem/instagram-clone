import 'package:cloud_firestore/cloud_firestore.dart';


class SingleNotification {
  String ownerId;
  String postUrl;
  Timestamp timestamp;
  String type;
  String ownerName;
  String comment;
  String postId;
  String userPhotoUrl;

  SingleNotification({
    this.postUrl,
    this.ownerId,
    this.timestamp,
    this.type = ' ',
    this.comment,
    this.postId,
    this.ownerName,
    this.userPhotoUrl
  });

  factory SingleNotification.fromDoc(DocumentSnapshot doc) {
    return SingleNotification(
        ownerId: doc['ownerId'],
        type: doc['type'],
        postUrl: doc['postUrl'],
        comment: doc['comment'],
        timestamp: doc['timestamp'],
        postId: doc['postId'],
        userPhotoUrl: doc['userPhotoUrl'],
        ownerName: doc['ownerName']);
  }

}
