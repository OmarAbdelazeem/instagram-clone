import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/widgets/post_widget.dart';
import 'package:uuid/uuid.dart';
import 'auth.dart';

class PostServices {
  final DateTime timestamp = DateTime.now();

//  static Post currentPost;

  final timelineRef = Firestore.instance.collection('timeline');
  final notificationRef = Firestore.instance.collection('notification');
  final likesRef = Firestore.instance.collection('likes');
  final commentsRef = Firestore.instance.collection('comments');
  final postsRef = Firestore.instance.collection('posts');

  Future<List<PostWidget>> getPosts({
    bool isTimeLine,
  }) async {
    QuerySnapshot snapshot;
    if (isTimeLine) {
      snapshot = await timelineRef
          .document(Data.defaultUser.id)
          .collection('timelinePosts')
          .orderBy('timestamp', descending: true)
          .getDocuments();
      List<PostWidget> posts = snapshot.documents.map((doc) {
        return PostWidget(
          post: Post.fromDocument(doc),
        );
      }).toList();
      return posts;
    }
  }

  Future<Post> getPostInfo({String postId}) async {
    DocumentReference postReference = postsRef
        .document(Data.defaultUser.id)
        .collection('userPosts')
        .document(postId);
    DocumentSnapshot postSnapshot = await postReference.get();
    Post post = Post.fromDocument(postSnapshot);
    return post;
  }

  Future<bool> checkIfLiking() async {
    DocumentSnapshot doc = await likesRef
        .document(Data.defaultUser.id)
        .collection('userLikes')
        .document(Data.currentPost.postId)
        .get();
    print('doc.exists is ${doc.exists}');
    return doc.exists;
  }

  void handleLiking({bool isLiking}) async {
    if (isLiking) {
      await likesRef
          .document(Data.defaultUser.id)
          .collection('userLikes')
          .document(Data.currentPost.postId)
          .delete();
      postsRef.document(Data.currentPost.publisherId).collection('userPosts').document(Data.currentPost.postId).updateData({
        'likes': FieldValue.arrayRemove([Data.defaultUser.id])
      });

      await notificationRef
          .document(Data.currentPost.publisherId)
          .collection('userNotification')
          .document(Data.currentPost.postId)
          .get()
          .then((doc) {
        if (doc.exists) doc.reference.delete();
      });
    } else {
      await likesRef
          .document(Data.defaultUser.id)
          .collection('userLikes')
          .document(Data.currentPost.postId)
          .setData({});
      print('current post id is ${Data.currentPost.postId}');

      postsRef.document(Data.currentPost.publisherId).collection('userPosts').document(Data.currentPost.postId).updateData({
        'likes': FieldValue.arrayUnion([Data.defaultUser.id])
      });

      postsRef
          .document(Data.currentPost.publisherId)
          .collection('userPosts')
          .document(Data.currentPost.postId)
          .updateData({
        'likes': FieldValue.arrayUnion([Data.defaultUser.id])
      });

      await notificationRef
          .document(Data.currentPost.publisherId)
          .collection('userNotification')
          .document(Data.currentPost.postId)
          .setData({
        'ownerId': Data.defaultUser.id,
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
        .document(Data.currentPost.postId)
        .collection('postComments')
        .document(commentId)
        .setData({
      'userId': Data.defaultUser.id,
      'userName': Data.defaultUser.userName,
      'userPhotoUrl': Data.defaultUser.photoUrl,
      'commentId': commentId,
      'userComment': comment,
      'timestamp': timestamp,
      'postId': Data.currentPost.postId
    });

    await notificationRef
        .document(Data.currentPost.publisherId)
        .collection('userNotification')
        .document(commentId)
        .setData({
      'ownerId': Data.defaultUser.id,
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
