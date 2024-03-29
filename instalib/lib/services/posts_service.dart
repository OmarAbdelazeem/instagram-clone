import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/widgets/post_widget.dart';
import 'package:uuid/uuid.dart';
import 'auth.dart';

class PostServices {
  final DateTime timestamp = DateTime.now();

//  static Post currentPost;

  final timelineRef = FirebaseFirestore.instance.collection('timeline');
  final notificationRef = FirebaseFirestore.instance.collection('notification');
  final likesRef = FirebaseFirestore.instance.collection('likes');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final postsRef = FirebaseFirestore.instance.collection('posts');

  Future<List<PostWidget>> getPosts({
    bool isTimeLine,
  }) async {
    QuerySnapshot snapshot;
    if (isTimeLine) {
      snapshot = await timelineRef
          .doc(Data.defaultUser.searchedUserId)
          .collection('timelinePosts')
          .orderBy('timestamp', descending: true)
          .get();
      List<PostWidget> posts = snapshot.docs.map((doc) {
        return PostWidget(
          post: Post.fromDocument(doc),
        );
      }).toList();
      return posts;
    }
  }

  Future<Post> getPostInfo({String postId}) async {
    DocumentReference postReference = postsRef
        .doc(Data.defaultUser.searchedUserId)
        .collection('userPosts')
        .doc(postId);
    DocumentSnapshot postSnapshot = await postReference.get();
    Post post = Post.fromDocument(postSnapshot);
    return post;
  }

  Future<bool> checkIfLiking() async {
    DocumentSnapshot doc = await likesRef
        .doc(Data.defaultUser.searchedUserId)
        .collection('userLikes')
        .doc(Data.currentPost.postId)
        .get();
    print('doc.exists is ${doc.exists}');
    return doc.exists;
  }

  void handleLiking({bool isLiking}) async {
    if (isLiking) {
      await likesRef
          .doc(Data.defaultUser.searchedUserId)
          .collection('userLikes')
          .doc(Data.currentPost.postId)
          .delete();
      postsRef.doc(Data.currentPost.publisherId).collection('userPosts').doc(Data.currentPost.postId).update({
        'likes': FieldValue.arrayRemove([Data.defaultUser.searchedUserId])
      });

      await notificationRef
          .doc(Data.currentPost.publisherId)
          .collection('userNotification')
          .doc(Data.currentPost.postId)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });
    } else {
      await likesRef
          .doc(Data.defaultUser.searchedUserId)
          .collection('userLikes')
          .doc(Data.currentPost.postId)
          .set({});
      print('current post id is ${Data.currentPost.postId}');

      postsRef.doc(Data.currentPost.publisherId).collection('userPosts').doc(Data.currentPost.postId).update({
        'likes': FieldValue.arrayUnion([Data.defaultUser.searchedUserId])
      });

      postsRef
          .doc(Data.currentPost.publisherId)
          .collection('userPosts')
          .doc(Data.currentPost.postId)
          .update({
        'likes': FieldValue.arrayUnion([Data.defaultUser.searchedUserId])
      });

      await notificationRef
          .doc(Data.currentPost.publisherId)
          .collection('userNotification')
          .doc(Data.currentPost.postId)
          .set({
        'ownerId': Data.defaultUser.searchedUserId,
        'type': 'like',
        'timestamp': timestamp,
        'postUrl': Data.currentPost.photoUrl,
        'ownerName': Data.defaultUser.userName,
        'postId': Data.currentPost.postId,
        'userPhotoUrl': Data.defaultUser.photoUrl
      });
    }
  }

//  void changeCurrentPost(Post post) {
//    currentPost = post;
//  }

  void addComment(String comment) async {
//    final commentId = await _commentsRef.get();
    String commentId = Uuid().v4();
    await commentsRef
        .doc(Data.currentPost.postId)
        .collection('postComments')
        .doc(commentId)
        .set({
      'userId': Data.defaultUser.searchedUserId,
      'userName': Data.defaultUser.userName,
      'userPhotoUrl': Data.defaultUser.photoUrl,
      'commentId': commentId,
      'userComment': comment,
      'timestamp': timestamp,
      'postId': Data.currentPost.postId
    });

    await notificationRef
        .doc(Data.currentPost.publisherId)
        .collection('userNotification')
        .doc(commentId)
        .set({
      'ownerId': Data.defaultUser.searchedUserId,
      'type': 'comment',
      'timestamp': timestamp,
      'postUrl': Data.currentPost.photoUrl,
      'comment': comment,
      'ownerName': Data.defaultUser.userName,
      'postId': Data.currentPost.postId,
      'userPhotoUrl': Data.defaultUser.photoUrl
    });
  }
}
