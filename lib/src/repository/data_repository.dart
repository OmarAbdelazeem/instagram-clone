import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';

import '../models/comment_model/comment_model.dart';
import '../models/post_model/post_model.dart';

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

  Stream<Iterable<QueryDocumentSnapshot<Map<String, dynamic>>>> searchForUser(
      {required String term, DocumentSnapshot? documentSnapshot}) {
    final usersSnapshot =
        usersRef.snapshots().map((event) => event.docs.where((doc) {
              final bool condition = (doc.data()["userName"] as String)
                  .trim()
                  .toLowerCase()
                  .contains(term.trim().toLowerCase());
              return condition;
            }));
    return usersSnapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserPosts(
      {required String userId, DocumentSnapshot? documentSnapshot}) async {
    var postsRequest = postsRef
        .orderBy('timestamp', descending: true)
        .limit(12)
        .where("publisherId", isEqualTo: userId);
    if (documentSnapshot == null) {
      return await postsRequest.get();
    } else {
      return await postsRequest.startAfterDocument(documentSnapshot).get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getExplorePosts(
      {DocumentSnapshot? documentSnapshot}) async {
    final postsRequest =
        postsRef.orderBy('timestamp', descending: true).limit(18);
    if (documentSnapshot == null) {
      return await postsRequest.get();
    } else {
      return await postsRequest.startAfterDocument(documentSnapshot).get();
    }
  }

  Future<QuerySnapshot> getTimelinePostsIds(
      {DocumentSnapshot? documentSnapshot}) {
    var timelineRequest = timelineRef
        .doc(loggedInUserId)
        .collection('timeline')
        .orderBy("timestamp", descending: true)
        .limit(10);
    if (documentSnapshot == null) {
      return timelineRequest.get();
    } else {
      return timelineRequest.startAfterDocument(documentSnapshot).get();
    }
  }

  Stream<QuerySnapshot> listenToTimeline(String userId) {
    return timelineRef.doc(userId).collection("timeline").snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostComments(
      {required String postId, DocumentSnapshot? documentSnapshot}) async {
    final commentsRequest = postsCommentsRef
        .doc(postId)
        .collection("postsComments")
        .orderBy("timestamp", descending: true)
        .limit(15);
    if (documentSnapshot == null) {
      return await commentsRequest.get();
    } else {
      return await commentsRequest.startAfterDocument(documentSnapshot).get();
    }
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

  addLikeToPost({required String postId}) async {
    /// 1) add user id to postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(loggedInUserId)
        .set({"timestamp": Timestamp.now()});
  }

  removeLikeFromPost({required String postId}) async {
    /// 1) remove user id from postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(loggedInUserId)
        .delete();
  }

  Future addComment(CommentModel commentRequest) async {
    /// 1) add comment to postsComments collection of post

    await postsCommentsRef
        .doc(commentRequest.postId)
        .collection('postsComments')
        .doc(commentRequest.commentId)
        .set(commentRequest.toJson());
  }

  Future removeComment(CommentModel comment) async {
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
    PostModel post,
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

    await for (var snapshot in usersRef.limit(12).snapshots()) {
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

  Future<QuerySnapshot> getFollowersIds(
      {DocumentSnapshot? documentSnapshot, required String userId}) async {
    final userFollowersRequest =
        usersFollowersRef.doc(userId).collection("usersFollowers").limit(15);

    if (documentSnapshot == null) {
      return await userFollowersRequest.get();
    } else {
      return await userFollowersRequest
          .startAfterDocument(documentSnapshot)
          .get();
    }
  }

  Future<QuerySnapshot> getFollowingIds(
      {DocumentSnapshot? documentSnapshot, required String userId}) async {
    final userFollowingRequest =
        usersFollowingRef.doc(userId).collection("usersFollowing").limit(15);

    if (documentSnapshot == null) {
      return userFollowingRequest.get();
    } else {
      return userFollowingRequest.startAfterDocument(documentSnapshot).get();
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    await usersRef.doc(loggedInUserId).update(data);
  }

  Future<void> editPostCaption(
      {required String value, required String postId}) async {
    await postsRef.doc(postId).update({"caption": value});
  }

  Future<QuerySnapshot> getNotifications(
      {DocumentSnapshot? documentSnapshot}) async {
    var notificationRequest = notificationsRef
        .doc(loggedInUserId)
        .collection("notifications")
        .orderBy('timestamp', descending: true)
        .limit(10);
    if (documentSnapshot != null) {
      return await notificationRequest
          .startAfterDocument(documentSnapshot)
          .get();
    } else {
      return await notificationRequest.get();
    }
  }
}
