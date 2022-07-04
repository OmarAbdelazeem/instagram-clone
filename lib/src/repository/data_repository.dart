import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model_request/comment_model_request.dart';
import 'package:instagramapp/src/models/post_model/post_model_request/post_model_request.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';

class DataRepository {
  final AuthRepository _authRepository;

  DataRepository(this._authRepository);

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
  final usersFollowersRef =
      FirebaseFirestore.instance.collection("usersFollowers");
  final usersFollowingRef =
      FirebaseFirestore.instance.collection("usersFollowing");

  String get loggedInUserId {
    return _authRepository.loggedInUser!.uid;
  }

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await usersRef.doc(userId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToUserDetails(
      String id) {
    return usersRef.doc(id).snapshots();
  }

  Future createUserDetails(UserModel user) async {
    await usersRef.doc(user.id).set(user.toJson());
  }

  Future<QuerySnapshot> searchForUser(String term) {
    return usersRef.where("userName", isGreaterThanOrEqualTo: term).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserPosts(
      String userId) async {
    return await postsRef
        .orderBy('timestamp', descending: true)
        .where("publisherId", isEqualTo: userId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getExplorePosts() async {
    return await postsRef.orderBy('timestamp', descending: true).get();
  }

  Future<QuerySnapshot?>? getTimelinePostsIds(String userId) {
    return timelineRef
        .doc(userId)
        .collection('timeline')
        .orderBy("timestamp", descending: true)
        // .limit(10)
        .get();
  }

  Stream<QuerySnapshot> listenToTimeline(String userId) {
    return timelineRef.doc(userId).collection("timeline").snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostComments(
      String postId) async {
    return await postsCommentsRef.doc(postId).collection("postsComments").get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getPostDetails(
      {required String postId}) async {
    final postData = await postsRef.doc(postId).get();
    if (postData.exists)
      return postData;
    else
      return null;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToPostDetails(
      {required String postId}) {
    return postsRef.doc(postId).get().asStream();
  }

  Future<bool> checkIfUserLikesPost(String postId) async {
    return (await postsLikesRef
            .doc(postId)
            .collection("postsLikes")
            .doc(loggedInUserId)
            .get())
        .exists;
  }

  addLikeToPost({required String postId, required String userId}) async {
    /// 1) add user id to postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .set({"timestamp": Timestamp.now()});
  }

  removeLikeFromPost(
      {required String postId, required String publisherId}) async {
    /// 1) remove user id from postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(publisherId)
        .delete();

    // /// 2) decrement likesCount of post

    // postsRef.doc(postId).update({"likesCount": FieldValue.increment(-1)});
  }

  Future addComment(CommentModelRequest commentRequest) async {
    /// 1) add comment to postsComments collection of post

    await postsCommentsRef
        .doc(commentRequest.postId)
        .collection('postsComments')
        .doc(commentRequest.commentId)
        .set(commentRequest.toJson());
  }

  Future removeComment(CommentModelRequest comment) async {
    /// 1) remove comment from postsComments collection of post

    await postsCommentsRef
        .doc(comment.postId)
        .collection('postsComments')
        .doc(comment.commentId)
        .delete();
  }

  Future addProfilePhoto(String userId, String photoUrl) async {
    await usersRef.doc(userId).update({
      'photoUrl': photoUrl,
    });
  }

  Future addPost(
    PostModelRequest post,
  ) async {
    /// 1) add post in publisher postsRef
    await postsRef.doc(post.postId).set(post.toJson());
  }

  addFollowing({required String receiverId}) async {
    ///1) add receiver id to sender usersFollowing collection
    await usersFollowingRef
        .doc(loggedInUserId)
        .collection("usersFollowing")
        .doc(receiverId)
        .set({"timestamp": Timestamp.now()});
  }

  removeFollowing({required String receiverId}) async {
    ///1) remove receiver id from sender usersFollowing collection
    await usersFollowingRef
        .doc(loggedInUserId)
        .collection("usersFollowing")
        .doc(receiverId)
        .delete();
  }

  Future<bool> checkIfUserFollowingSearched(
      {required String receiverId}) async {
    return (await usersFollowingRef
            .doc(loggedInUserId)
            .collection("usersFollowing")
            .doc(receiverId)
            .get())
        .exists;
  }

//Todo implement this function to fetch all recommended users
  Future<List<QueryDocumentSnapshot>> getRecommendedUsers() async {
    List<QueryDocumentSnapshot> queryDocumentSnapshots = [];

    await for (var snapshot in usersRef.snapshots()) {
      for (var snapshotDoc in snapshot.docs) {
        String userId = snapshotDoc.data()['id'];
        if (userId == loggedInUserId) continue;
        final userIsFollowed = (await usersFollowingRef
                .doc(loggedInUserId)
                .collection("usersFollowing")
                .doc(userId)
                .get())
            .exists;

        if (!userIsFollowed) queryDocumentSnapshots.add(snapshotDoc);
      }
      return queryDocumentSnapshots;
    }

    return [];
  }

  Future<List<DocumentSnapshot>> getFollowers() async {
    List<DocumentSnapshot> followersDocumentSnapshots = [];

    final loggedInUserFollowersRef =
        usersFollowersRef.doc(loggedInUserId).collection("usersFollowers");
    await for (var snapshot in loggedInUserFollowersRef.snapshots()) {
      for (var snapshotDoc in snapshot.docs) {
        final followerData = await usersRef.doc(snapshotDoc.id).get();

        followersDocumentSnapshots.add(followerData);
      }
      return followersDocumentSnapshots;
    }

    return [];
  }

  Future<List<DocumentSnapshot>> getFollowing() async {
    List<DocumentSnapshot> followingDocumentSnapshots = [];

    final loggedInUserFollowingRef =
        usersFollowingRef.doc(loggedInUserId).collection("usersFollowing");
    await for (var snapshot in loggedInUserFollowingRef.snapshots()) {
      for (var snapshotDoc in snapshot.docs) {
        final followerData = await usersRef.doc(snapshotDoc.id).get();

        followingDocumentSnapshots.add(followerData);
      }
      return followingDocumentSnapshots;
    }

    return [];
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    await usersRef.doc(loggedInUserId).update(data);
  }

  Future<QuerySnapshot> getNotifications() async {
   return await notificationsRef.doc(loggedInUserId).collection("notifications").get();
  }
}
