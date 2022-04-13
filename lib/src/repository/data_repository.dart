import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
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
  final usersLikesRef = FirebaseFirestore.instance.collection("usersLikes");
  final usersFollowersRef =
      FirebaseFirestore.instance.collection("usersFollowers");
  final usersFollowingRef =
      FirebaseFirestore.instance.collection("usersFollowing");

  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await usersRef.doc(userId).get();
  }

  Stream<DocumentSnapshot> listenToUserDetails(String id) {
    return usersRef.doc(id).snapshots();
  }

  Future createUserDetails(UserModel user) async {
    await usersRef.doc(user.id).set(user.toJson());
  }

  Stream<QuerySnapshot> searchForUser(String term) {
    return usersRef.where("userName", isGreaterThanOrEqualTo: term).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserPosts(
      String userId) async {
    return await postsRef
        .doc(userId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTimelinePosts(
      String userId) async {
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
    return (await usersLikesRef
            .doc(userId)
            .collection("usersLikes")
            .doc(postId)
            .get())
        .exists;
  }

  addLikeToPost(String postId, String userId) async {
    /// 1) add user id to postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .set({});

    /// 2) increment likesCount of post

    postsRef
        .doc(userId)
        .collection("posts")
        .doc(postId)
        .update({"likesCount": FieldValue.increment(1)});
  }

  removeLikeFromPost(String postId, String userId) async {
    /// 1) remove user id from postsLikes collection of post

    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .delete();

    /// 2) decrement likesCount of post

    postsRef
        .doc(userId)
        .collection("posts")
        .doc(postId)
        .update({"likesCount": FieldValue.increment(-1)});
  }

  Future addComment(CommentModel comment) async {
    /// 1) add comment to postsComments collection of post

    await postsCommentsRef
        .doc(comment.publisherId)
        .collection('postsComments')
        .doc(comment.commentId)
        .set(comment.toJson());

    /// 2) increment commentsCount of post

    postsRef
        .doc(comment.publisherId)
        .collection("posts")
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
        .doc(comment.publisherId)
        .collection("posts")
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
    await postsRef
        .doc(post.publisherId)
        .collection("posts")
        .doc(post.postId)
        .set(post.toJson());

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
        .doc(receiverId)
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .limit(5)
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
    ///1) remove receiver id to sender usersFollowing collection
    await usersFollowingRef
        .doc(senderId)
        .collection("usersFollowing")
        .doc(receiverId)
        .delete();

    /// 2) decrement following count to sender

    await usersRef
        .doc(senderId)
        .update({"followingCount": FieldValue.increment(-1)});

    ///3) delete sender from receiver usersFollowers receiver

    await usersFollowingRef
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

  Future<bool> checkIfUserFollowingSomeOne(
      {required String senderId, required String receiverId}) async {
    return (await usersFollowingRef
            .doc(senderId)
            .collection("usersFollowing")
            .doc(receiverId)
            .get())
        .exists;
  }

//Todo implement this function to fetch all recommended users
// getRecommendedUsers(String loggedInUserId) async {
//   // usersRef.snapshots().
//
//   var query =
//       usersRef.snapshots().map((snapshot) => snapshot.docs.where((doc) {
//             String userId = doc['userId'];
//             usersFollowingRef.doc(userId).get();
//           }));
//   // List<> recommendedUsers =[];
//
//   // var query =
//   // usersRef.snapshots().map((snapshot) => snapshot.docs.forEach((doc) async{
//   //  final isDocExist = (await usersRef.doc(doc.id).get()).exists;
//   //  // if(isDocExist)
//   //  //   recommendedUsers.add(doc);
//   // }));
//
// }
}
