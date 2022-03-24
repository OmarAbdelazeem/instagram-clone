import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:uuid/uuid.dart';

class DataRepository {
  final DateTime timestamp = DateTime.now();

  final timelineRef = FirebaseFirestore.instance.collection('timeline');
  final notificationsRef =
      FirebaseFirestore.instance.collection('notifications');
  final postsRef = FirebaseFirestore.instance.collection('posts');
  final postsLikesRef = FirebaseFirestore.instance.collection('postsLikes');
  final postsCommentsRef =
      FirebaseFirestore.instance.collection('postsComments');
  final usersRef = FirebaseFirestore.instance.collection('usersComments');
  final users = FirebaseFirestore.instance.collection("users");
  final usersComments = FirebaseFirestore.instance.collection("usersComments");
  final usersLikes = FirebaseFirestore.instance.collection("usersLikes");

  Future getUserDetails(String userId) async {
    return await users.doc(userId).get();
  }

  searchForUser(String term) {
    users.where("userName", isGreaterThanOrEqualTo: term).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPosts(String userId) async {
    print("getPosts callled");
    //Todo return collection to userPosts as before
    return await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTimeline(String userId) async {
    //Todo return collection to timelinePosts as before
    return await timelineRef
            .doc(userId)
            .collection('timelinePosts')
            .orderBy('timestamp', descending: true)
            .get();
  }

  Future getPostDetails(String postId, String userId) async {
    DocumentReference postReference =
        postsRef.doc(userId).collection("posts").doc(postId);
    return await postReference.get();
  }

  Future<bool> checkIfUserLikesPost(String userId, String postId) async {
    DocumentSnapshot doc =
        await postsLikesRef.doc(userId).collection('likes').doc(postId).get();
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

  void addComment(CommentModel commentModel) async {
    String commentId = Uuid().v4();
    await postsCommentsRef
        .doc(commentModel.ownerId)
        .collection('postComments')
        .doc(commentId)
        .set(commentModel.toJson());
  }
}
