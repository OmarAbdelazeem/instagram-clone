import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class Repository {
  final DateTime timestamp = DateTime.now();

//  static Post currentPost;

  final timelineRef = FirebaseFirestore.instance.collection('timeline');
  final notificationsRef = FirebaseFirestore.instance.collection('notifications');
  final likesRef = FirebaseFirestore.instance.collection('likes');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final postsRef = FirebaseFirestore.instance.collection('posts');

  Future getPosts(String userId) async {
    return await postsRef
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future getTimeline(String userId) async {
    return await timelineRef
        .doc(userId)
        .collection('timeline')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future getPostDetails(String postId, String userId) async {
    DocumentReference postReference =
        postsRef.doc(userId).collection("posts").doc(postId);
    return await postReference.get();
  }

  Future<bool> checkIfUserLikesPost(String userId , String postId) async {
    DocumentSnapshot doc = await likesRef
        .doc(userId)
        .collection('likes').doc(postId)
        .get();
    print('doc.exists is ${doc.exists}');
    return doc.exists;
  }

  // void handleLiking({bool isLiking}) async {
  //   if (isLiking) {
  //     await usersLikesRef
  //         .doc(Data.defaultUser.id)
  //         .collection('userLikes')
  //         .doc(Data.currentPost.postId)
  //         .delete();
  //     postsRef
  //         .doc(Data.currentPost.publisherId)
  //         .collection('userPosts')
  //         .doc(Data.currentPost.postId)
  //         .update({
  //       'likes': FieldValue.arrayRemove([Data.defaultUser.id])
  //     });
  //
  //     await notificationRef
  //         .doc(Data.currentPost.publisherId)
  //         .collection('userNotification')
  //         .doc(Data.currentPost.postId)
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) doc.reference.delete();
  //     });
  //   } else {
  //     await usersLikesRef
  //         .doc(Data.defaultUser.id)
  //         .collection('userLikes')
  //         .doc(Data.currentPost.postId)
  //         .set({});
  //     print('current post id is ${Data.currentPost.postId}');
  //
  //     postsRef
  //         .doc(Data.currentPost.publisherId)
  //         .collection('userPosts')
  //         .doc(Data.currentPost.postId)
  //         .update({
  //       'likes': FieldValue.arrayUnion([Data.defaultUser.id])
  //     });
  //
  //     postsRef
  //         .doc(Data.currentPost.publisherId)
  //         .collection('userPosts')
  //         .doc(Data.currentPost.postId)
  //         .update({
  //       'likes': FieldValue.arrayUnion([Data.defaultUser.id])
  //     });
  //
  //     await notificationRef
  //         .doc(Data.currentPost.publisherId)
  //         .collection('userNotification')
  //         .doc(Data.currentPost.postId)
  //         .set({
  //       'ownerId': Data.defaultUser.id,
  //       'type': 'like',
  //       'timestamp': timestamp,
  //       'postUrl': Data.currentPost.photoUrl,
  //       'ownerName': Data.defaultUser.userName,
  //       'postId': Data.currentPost.postId,
  //       'userPhotoUrl': Data.defaultUser.photoUrl
  //     });
  //   }
  // }

//  void changeCurrentPost(Post post) {
//    currentPost = post;
//  }

  void addComment(String comment , String postId) async {
//    final commentId = await _commentsRef.get();
    String commentId = Uuid().v4();
    await commentsRef
        .doc(Data.currentPost.postId)
        .collection('postComments')
        .doc(commentId)
        .set({
      'userId': Data.defaultUser.id,
      'userName': Data.defaultUser.userName,
      'userPhotoUrl': Data.defaultUser.photoUrl,
      'commentId': commentId,
      'userComment': comment,
      'timestamp': timestamp,
      'postId': Data.currentPost.postId
    });

    // await notificationRef
    //     .doc(Data.currentPost.publisherId)
    //     .collection('userNotification')
    //     .doc(commentId)
    //     .set({
    //   'ownerId': Data.defaultUser.id,
    //   'type': 'comment',
    //   'timestamp': timestamp,
    //   'postUrl': Data.currentPost.photoUrl,
    //   'comment': comment,
    //   'ownerName': Data.defaultUser.userName,
    //   'postId': Data.currentPost.postId,
    //   'userPhotoUrl': Data.defaultUser.photoUrl
    // });
  }
}
