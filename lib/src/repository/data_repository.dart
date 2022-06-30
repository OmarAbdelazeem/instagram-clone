import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
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

  Future<QuerySnapshot<Map<String, dynamic>>> getExplorePosts(
      String userId) async {
    return await postsRef.orderBy('timestamp', descending: true).get();
  }

  Future<QuerySnapshot?>? getTimelinePostsIds(String userId) {
    return timelineRef
        .doc(userId)
        .collection('timeline')
        .orderBy("timestamp", descending: true)
        .limit(10)
        .get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToTimeline(
      String userId) {
    return timelineRef.doc(userId).get().asStream();
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

  Future<bool> checkIfUserLikesPost( String postId) async {
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
        .set({});

    // /// 2) increment likesCount of post

    // postsRef.doc(postId).update({"likesCount": FieldValue.increment(1)});
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

  Future addComment(CommentModel comment) async {
    /// 1) add comment to postsComments collection of post

    await postsCommentsRef
        .doc(comment.postId)
        .collection('postsComments')
        .doc(comment.commentId)
        .set(comment.toJson());

    // /// 2) increment commentsCount of post

    // postsRef
    //     .doc(comment.postId)
    //     .update({"commentsCount": FieldValue.increment(1)});
  }

  Future removeComment(CommentModel comment) async {
    /// 1) remove comment from postsComments collection of post

    await postsCommentsRef
        .doc(comment.publisherId)
        .collection('postsComments')
        .doc(comment.commentId)
        .delete();

    // /// 2) decrement commentsCount of post

    // postsRef
    //     .doc(comment.postId)
    //     .update({"commentsCount": FieldValue.increment(-1)});
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

  addFollower({required String receiverId}) async {
    //Todo try to implement this behaviour by cloud functions

    ///1) add receiver id to sender usersFollowing collection
    await usersFollowingRef
        .doc(loggedInUserId)
        .collection("usersFollowing")
        .doc(receiverId)
        .set({});

    // /// 2) increment following count to sender

    // await usersRef
    //     .doc(senderId)
    //     .update({"followingCount": FieldValue.increment(1)});

    // ///3) add sender id to receiver usersFollowers receiver

    // await usersFollowersRef
    //     .doc(receiverId)
    //     .collection("usersFollowers")
    //     .doc(senderId)
    //     .set({});

    // ///4) increment followers count to receiver

    // await usersRef
    //     .doc(receiverId)
    //     .update({"followersCount": FieldValue.increment(1)});

    // ///5) add receiver posts to sender timeline
    // var postsQuerySnapshot = await postsRef
    //     .orderBy("timestamp", descending: true)
    //     .where("publisherId", isEqualTo: receiverId)
    //     .limit(3)
    //     .get();
    // postsQuerySnapshot.docs.forEach((doc) async {
    //   await timelineRef
    //       .doc(senderId)
    //       .collection("timeline")
    //       .doc(doc.id)
    //       .set({"publisherId": receiverId});
    // });
  }

  removeFollower({required String receiverId}) async {
    ///1) remove receiver id from sender usersFollowing collection
    await usersFollowingRef
        .doc(loggedInUserId)
        .collection("usersFollowing")
        .doc(receiverId)
        .delete();

    // /// 2) decrement following count to sender
    //
    // await usersRef
    //     .doc(loggedInUserId)
    //     .update({"followingCount": FieldValue.increment(-1)});
    //
    // ///3) remove senderId from receiver usersFollowers receiver
    //
    // await usersFollowersRef
    //     .doc(receiverId)
    //     .collection("usersFollowers")
    //     .doc(loggedInUserId)
    //     .delete();
    //
    // ///4) decrement followers count to receiver
    //
    // await usersRef
    //     .doc(receiverId)
    //     .update({"followersCount": FieldValue.increment(-1)});
    //
    // ///5) delete receiver posts from sender timeline
    //
    // var senderTimelineRef = timelineRef.doc(senderId).collection("timeline");
    // var timelineQueries = await senderTimelineRef
    //     .where("publisherId", isEqualTo: receiverId)
    //     .get();
    //
    // timelineQueries.docs.forEach((doc) async {
    //   await senderTimelineRef.doc(doc.id).delete();
    // });
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
}
