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
  final usersRef = FirebaseFirestore.instance.collection("users");
  final usersCommentsRef =
      FirebaseFirestore.instance.collection("usersComments");
  final usersLikes = FirebaseFirestore.instance.collection("usersLikes");

  Future getUserDetails(String userId) async {
    return await usersRef.doc(userId).get();
  }

  searchForUser(String term) {
    usersRef.where("userName", isGreaterThanOrEqualTo: term).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPosts(String userId) async {
    return await postsRef
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTimeline(String userId) async {
    return await timelineRef
        .doc(userId)
        .collection('timeline')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostDetails(
      String postId, String userId) async {
    return await postsRef.doc(userId).collection("posts").doc(postId).get();
  }

  Future<bool> checkIfUserLikesPost(String userId, String postId) async {
    return (await usersLikes
            .doc(userId)
            .collection("usersLikes")
            .doc(postId)
            .get())
        .exists;
  }

  addLikeToPost(String postId, String userId) async {
    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .set({});
  }

  removeLikeFromPost(String postId, String userId)async{
    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .delete();
  }

  void addComment(CommentModel commentModel) async {
    String commentId = Uuid().v4();
    await postsCommentsRef
        .doc(commentModel.ownerId)
        .collection('postComments')
        .doc(commentId)
        .set(commentModel.toJson());
  }
}
