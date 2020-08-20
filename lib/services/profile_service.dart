import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'auth.dart';

class ProfileService {
  final usersRef = Firestore.instance.collection('users');
  final followersRef = Firestore.instance.collection('followers');
  final followingRef = Firestore.instance.collection('following');
  final postsRef = Firestore.instance.collection('posts');
  final notificationRef = Firestore.instance.collection('notification');
  final commentsRef = Firestore.instance.collection('comments');
  final DateTime timestamp = DateTime.now();

//  static User neededUser;

//  static List unFollowedUsers;
//  static List followingUsers;
//  static bool isMyProfile;

//  void changeNeededUser(User user) {
//    neededUser = user;
//  }
//
//  Future updateNeedUser() async {
//    neededUser = await getProfileMainInfo(id: neededUser.id);
//  }

  Future setDataForNewUser({String timeStamp, String androidToken}) async {
    return await usersRef.document(Data.defaultUser.id).setData({
      'id': Data.defaultUser.id,
      'userName': Data.defaultUser.userName,
      'email': Data.defaultUser.email,
      'photoUrl': '',
      'bio': '',
      'followersCount': 0,
      'followingCount': 0,
      'postsCount': 0,
      'timestamp': timestamp
    });
  }

  Future<QuerySnapshot> getFuturePosts(String id) async {
    return await postsRef.document(id).collection('userPosts').getDocuments();
  }

  Future<QuerySnapshot> getFollowingUsers({@required bool isMyProfile}) async {
    String id;
    isMyProfile ? id = Data.defaultUser.id : id = Data.currentUser.id;
    QuerySnapshot snapshot = await followingRef
        .document(id)
        .collection('userFollowing')
        .getDocuments();
    return snapshot;
  }

  Future<QuerySnapshot> getFollowersUsers({@required bool isMyProfile}) async {
    String id;
    isMyProfile ? id = Data.defaultUser.id : id = Data.currentUser.id;
    QuerySnapshot snapshot = await followersRef
        .document(id)
        .collection('userFollowers')
        .getDocuments();
    return snapshot;
  }

  Future<User> getProfileMainInfo({String id}) async {
    DocumentReference docRef = usersRef.document(id);
    DocumentSnapshot userDoc = await docRef.get();
    User user = User.fromDocument(userDoc);
    return user;
  }

  Future<bool> checkIfFollowing({@required bool forNeededUser}) async {
    bool isFollowing = false;
    DocumentSnapshot doc;
    if (!forNeededUser) {
      doc = await followingRef
          .document(Data.defaultUser.id)
          .collection('userFollowing')
          .document(Data.currentUser.id)
          .get();
      if(doc.exists)
        isFollowing = doc['isFollowing'];
      else isFollowing = doc.exists;
    } else {
      doc = await followingRef
          .document(Data.currentUser.id)
          .collection('userFollowing')
          .document(Data.defaultUser.id)
          .get();
      if(doc.exists)
        isFollowing = doc['isFollowing'];
      else isFollowing = doc.exists;
    }

    return isFollowing;
  }

//  Future unFollowWithoutDelete() async {
//    await followingRef
//        .document(Data.defaultUser.id)
//        .collection('userFollowing')
//        .document(Data.currentUser.id)
//        .updateData({'isFollowing': false});
//  }

  Future unFollowOperation() async {
    await followingRef
        .document(Data.defaultUser.id)
        .collection('userFollowing')
        .document(Data.currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

      await followersRef
          .document(Data.currentUser.id)
          .collection('userFollowers')
          .document(Data.defaultUser.id)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });

      await notificationRef
          .document(Data.currentUser.id)
          .collection('userNotification')
          .document(Data.defaultUser.id)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });

  }

  void followingOperation() async {
    await followingRef
        .document(Data.defaultUser.id)
        .collection('userFollowing')
        .document(Data.currentUser.id)
        .setData({
      'id': Data.currentUser.id,
      'photoUrl': Data.currentUser.photoUrl,
      'userName': Data.currentUser.userName,
      'isFollowing': true
    });

    bool followerExist = await checkIfFollowing(forNeededUser: true);

    await followersRef
        .document(Data.currentUser.id)
        .collection('userFollowers')
        .document(Data.defaultUser.id)
        .setData({
      'id': Data.defaultUser.id,
      'photoUrl': Data.defaultUser.photoUrl,
      'userName': Data.defaultUser.userName,
      'isFollowing': followerExist
    });

    if (followerExist) {
      await followersRef
          .document(Data.defaultUser.id)
          .collection('userFollowers')
          .document(Data.currentUser.id)
          .updateData({'isFollowing': followerExist});
    }

//    await usersRef.document(Data.defaultUser.id).updateData(
//        {'followingCount': Data.defaultUser.followingCount + 1});
//
//    await usersRef
//        .document(Data.currentUser.id)
//        .updateData({'followersCount': Data.currentUser.followersCount + 1});

    await notificationRef
        .document(Data.currentUser.id)
        .collection('userNotification')
        .document(Data.defaultUser.id)
        .setData({
      'ownerId': Data.defaultUser.id,
      'type': 'follow',
      'timestamp': timestamp,
      'ownerName': Data.defaultUser.userName,
      'userPhotoUrl': Data.defaultUser.photoUrl
    });
  }
}
