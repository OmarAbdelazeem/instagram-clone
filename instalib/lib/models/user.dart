import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserModel with ChangeNotifier{
  String bio;
  String id;
  String userName;
  String photoUrl;
  String email;
  int followingCount;
  int followersCount;
  int postsCount;
  Timestamp timestamp;

  UserModel({
    this.photoUrl,
    this.userName,
    this.bio,
    this.id,
    this.email,
    this.timestamp
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc['id'],
        email: doc['email'],
        userName: doc['userName'],
        photoUrl: doc['photoUrl'],
        bio: doc['bio'],
        timestamp: doc['timestamp']
    );
  }

}
