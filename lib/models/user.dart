import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class User with ChangeNotifier{
  String bio;
  String id;
  String userName;
  String photoUrl;
  String email;
  int followingCount;
  int followersCount;
  int postsCount;
  Timestamp timestamp;

  User({
    this.photoUrl,
    this.userName,
    this.bio,
    this.id,
    this.email,
    this.timestamp
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        email: doc['email'],
        userName: doc['userName'],
        photoUrl: doc['photoUrl'],
        bio: doc['bio'],
        timestamp: doc['timestamp']
    );
  }

}
