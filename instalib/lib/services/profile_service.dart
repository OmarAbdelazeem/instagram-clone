import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'auth.dart';

class ProfileService {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final followingRef = FirebaseFirestore.instance.collection('following');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final notificationRef = FirebaseFirestore.instance.collection('notification');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
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
    return await usersRef.doc(Data.defaultUser.searchedUserId).set({
      'id': Data.defaultUser.searchedUserId,
      'userName': Data.defaultUser.userName,
      'email': Data.defaultUser.name,
      'photoUrl': '',
      'bio': '',
      'followersCount': 0,
      'followingCount': 0,
      'postsCount': 0,
      'timestamp': timestamp
    });
  }

  Future<QuerySnapshot> getFuturePosts(String id) async {
    return await postsRef.doc(id).collection('userPosts').get();
  }

  Future<QuerySnapshot> getFollowingUsers({@required bool isMyProfile}) async {
    String id;
    isMyProfile ? id = Data.defaultUser.searchedUserId : id = Data.currentUser.searchedUserId;
    QuerySnapshot snapshot = await followingRef
        .doc(id)
        .collection('userFollowing')
        .get();
    return snapshot;
  }

  Future<QuerySnapshot> getFollowersUsers({@required bool isMyProfile}) async {
    String id;
    isMyProfile ? id = Data.defaultUser.searchedUserId : id = Data.currentUser.searchedUserId;
    QuerySnapshot snapshot = await followersRef
        .doc(id)
        .collection('userFollowers')
        .get();
    return snapshot;
  }

  Future<UserModel> getProfileMainInfo({String id}) async {
    DocumentReference docRef = usersRef.doc(id);
    DocumentSnapshot userDoc = await docRef.get();
    UserModel user = UserModel.fromDocument(userDoc);
    return user;
  }

  Future<bool> checkIfFollowing({@required bool forNeededUser}) async {
    bool isFollowing = false;
    DocumentSnapshot doc;
    if (!forNeededUser) {
      doc = await followingRef
          .doc(Data.defaultUser.searchedUserId)
          .collection('userFollowing')
          .doc(Data.currentUser.searchedUserId)
          .get();
      if(doc.exists)
        isFollowing = doc['isFollowing'];
      else isFollowing = doc.exists;
    } else {
      doc = await followingRef
          .doc(Data.currentUser.searchedUserId)
          .collection('userFollowing')
          .doc(Data.defaultUser.searchedUserId)
          .get();
      if(doc.exists)
        isFollowing = doc['isFollowing'];
      else isFollowing = doc.exists;
    }

    return isFollowing;
  }

//  Future unFollowWithoutDelete() async {
//    await followingRef
//        .doc(Data.defaultUser.id)
//        .collection('userFollowing')
//        .doc(Data.currentUser.id)
//        .updateData({'isFollowing': false});
//  }

  Future unFollowOperation() async {
    await followingRef
        .doc(Data.defaultUser.searchedUserId)
        .collection('userFollowing')
        .doc(Data.currentUser.searchedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

      await followersRef
          .doc(Data.currentUser.searchedUserId)
          .collection('userFollowers')
          .doc(Data.defaultUser.searchedUserId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });

      await notificationRef
          .doc(Data.currentUser.searchedUserId)
          .collection('userNotification')
          .doc(Data.defaultUser.searchedUserId)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });

  }

  void followingOperation() async {
    await followingRef
        .doc(Data.defaultUser.searchedUserId)
        .collection('userFollowing')
        .doc(Data.currentUser.searchedUserId)
        .set({
      'id': Data.currentUser.searchedUserId,
      'photoUrl': Data.currentUser.photoUrl,
      'userName': Data.currentUser.userName,
      'isFollowing': true
    });

    bool followerExist = await checkIfFollowing(forNeededUser: true);

    await followersRef
        .doc(Data.currentUser.searchedUserId)
        .collection('userFollowers')
        .doc(Data.defaultUser.searchedUserId)
        .set({
      'id': Data.defaultUser.searchedUserId,
      'photoUrl': Data.defaultUser.photoUrl,
      'userName': Data.defaultUser.userName,
      'isFollowing': followerExist
    });

    if (followerExist) {
      await followersRef
          .doc(Data.defaultUser.searchedUserId)
          .collection('userFollowers')
          .doc(Data.currentUser.searchedUserId)
          .update({'isFollowing': followerExist});
    }

//    await usersRef.doc(Data.defaultUser.id).updateData(
//        {'followingCount': Data.defaultUser.followingCount + 1});
//
//    await usersRef
//        .doc(Data.currentUser.id)
//        .updateData({'followersCount': Data.currentUser.followersCount + 1});

    await notificationRef
        .doc(Data.currentUser.searchedUserId)
        .collection('userNotification')
        .doc(Data.defaultUser.searchedUserId)
        .set({
      'ownerId': Data.defaultUser.searchedUserId,
      'type': 'follow',
      'timestamp': timestamp,
      'ownerName': Data.defaultUser.userName,
      'userPhotoUrl': Data.defaultUser.photoUrl
    });
  }
}
