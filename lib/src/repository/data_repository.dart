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

  Future createUserDetails(UserModel user) async {
    print("user is ${user.toJson()}");
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
    //Todo


    await postsLikesRef
        .doc(postId)
        .collection("postsLikes")
        .doc(userId)
        .set({});
  }

  removeLikeFromPost(String postId, String userId) async {
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

  Future addProfilePhoto(String userId, String photoUrl) async {
    await usersRef.doc(userId).update({
      'photoUrl': photoUrl,
    });
  }

  Future addPost(
    PostModel post,
  ) async {
    await postsRef
        .doc(post.publisherId)
        .collection("posts")
        .doc(post.postId)
        .set(post.toJson());
  }

  // addFollower({required String receiverId, required String senderId}) async {
  //   await usersFollowersRef
  //       .doc(receiverId)
  //       .collection("usersFollowing")
  //       .doc(senderId)
  //       .set({});
  // }

  addFollower({required String receiverId, required String senderId}) async {
    //Todo
    // 1 - add senderId in receiver users followers
    // 2 - add receiver posts ids to sender timeline
    // 3 - update sender following count
    // 4 - update receiver followers count
    await usersFollowingRef
        .doc(senderId)
        .collection("usersFollowing")
        .doc(receiverId)
        .set({});
  }

  removeFollower({required String receiverId, required String senderId}) async {
    await usersFollowingRef
        .doc(senderId)
        .collection("usersFollowing")
        .doc(receiverId)
        .delete();
  }

  // removeFollower({required String receiverId, required String senderId}) async {
  //   await usersFollowersRef
  //       .doc(senderId)
  //       .collection("usersFollowers")
  //       .doc(senderId)
  //       .delete();
  // }

  Future<bool> checkIfUserFollowingSomeOne(
      {required String senderId,required String receiverId}) async {
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
