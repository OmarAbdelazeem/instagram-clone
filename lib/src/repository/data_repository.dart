import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';

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
  final usersFollowersRef =
      FirebaseFirestore.instance.collection("usersFollowers");
  final usersFollowingRef =
      FirebaseFirestore.instance.collection("usersFollowing");

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

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToTimelinePostsIds(
      String userId) {
    return timelineRef.doc(userId).collection('timeline').limit(10).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostComments(
      String postId) async {
    return await postsCommentsRef.doc(postId).collection("postsComments").get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostDetails(
      {required String postId}) async {
    return await postsRef.doc(postId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToPostDetails(
      {required String postId}) {
    return postsRef.doc(postId).get().asStream();
  }

  Future<bool> checkIfUserLikesPost(String userId, String postId) async {
    return (await postsLikesRef
            .doc(postId)
            .collection("postsLikes")
            .doc(userId)
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

    /// 2) increment likesCount of post

    postsRef.doc(postId).update({"likesCount": FieldValue.increment(1)});
  }

  removeLikeFromPost(
      {required String postId, required String publisherId}) async {
    /// 1) remove user id from postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(publisherId)
        .delete();

    /// 2) decrement likesCount of post

    postsRef.doc(postId).update({"likesCount": FieldValue.increment(-1)});
  }

  Future addComment(CommentModel comment) async {
    /// 1) add comment to postsComments collection of post

    await postsCommentsRef
        .doc(comment.postId)
        .collection('postsComments')
        .doc(comment.commentId)
        .set(comment.toJson());

    /// 2) increment commentsCount of post

    postsRef
        .doc(comment.postId)
        .update({"commentsCount": FieldValue.increment(1)});
  }

  Future removeComment(CommentModel comment) async {
    /// 1) remove comment from postsComments collection of post

    await postsCommentsRef
        .doc(comment.publisherId)
        .collection('postsComments')
        .doc(comment.commentId)
        .delete();

    /// 2) decrement commentsCount of post

    postsRef
        .doc(comment.postId)
        .update({"commentsCount": FieldValue.increment(-1)});
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

    /// 2) add post id to user followers timeline

    // 1 - get user followers ids
    var userFollowersQuerySnapshot = await usersFollowersRef
        .doc(post.publisherId)
        .collection("usersFollowers")
        .get();

    // 2 - update timeline to every follower
    userFollowersQuerySnapshot.docs.forEach((doc) {
      timelineRef
          .doc(doc.id)
          .collection("timeline")
          .doc(post.postId)
          .set({"publisherId": post.publisherId});
    });
  }

  addFollower({required String receiverId, required String senderId}) async {
    //Todo try to implement this behaviour by cloud functions

    ///1) add receiver id to sender usersFollowing collection
    await usersFollowingRef
        .doc(senderId)
        .collection("usersFollowing")
        .doc(receiverId)
        .set({});

    /// 2) increment following count to sender

    await usersRef
        .doc(senderId)
        .update({"followingCount": FieldValue.increment(1)});

    ///3) add sender id to receiver usersFollowers receiver

    await usersFollowersRef
        .doc(receiverId)
        .collection("usersFollowers")
        .doc(senderId)
        .set({});

    ///4) increment followers count to receiver

    await usersRef
        .doc(receiverId)
        .update({"followersCount": FieldValue.increment(1)});

    ///5) add receiver posts to sender timeline
    var postsQuerySnapshot = await postsRef
        .orderBy("timestamp", descending: true)
        .where("publisherId", isEqualTo: receiverId)
        .limit(3)
        .get();
    postsQuerySnapshot.docs.forEach((doc) async {
      await timelineRef
          .doc(senderId)
          .collection("timeline")
          .doc(doc.id)
          .set({"publisherId": receiverId});
    });
  }

  removeFollower({required String receiverId, required String senderId}) async {
    ///1) remove receiver id from sender usersFollowing collection
    await usersFollowingRef
        .doc(senderId)
        .collection("usersFollowing")
        .doc(receiverId)
        .delete();

    /// 2) decrement following count to sender

    await usersRef
        .doc(senderId)
        .update({"followingCount": FieldValue.increment(-1)});

    ///3) remove senderId from receiver usersFollowers receiver

    await usersFollowersRef
        .doc(receiverId)
        .collection("usersFollowers")
        .doc(senderId)
        .delete();

    ///4) decrement followers count to receiver

    await usersRef
        .doc(receiverId)
        .update({"followersCount": FieldValue.increment(-1)});

    ///5) delete receiver posts from sender timeline

    var senderTimelineRef = timelineRef.doc(senderId).collection("timeline");
    var timelineQueries = await senderTimelineRef
        .where("publisherId", isEqualTo: receiverId)
        .get();

    timelineQueries.docs.forEach((doc) async {
      await senderTimelineRef.doc(doc.id).delete();
    });
  }

  Future<bool> checkIfUserFollowingSearched(
      {required String senderId, required String receiverId}) async {
    return (await usersFollowingRef
            .doc(senderId)
            .collection("usersFollowing")
            .doc(receiverId)
            .get())
        .exists;
  }

//Todo implement this function to fetch all recommended users
  Future<List<QueryDocumentSnapshot>> getRecommendedUsers(
      String loggedInUserId) async {
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
      print("the end of the stream");
      return queryDocumentSnapshots;
    }

    return [];
  }
}
