import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/widgets/comment_widget.dart';
import 'package:instagramapp/services/posts_service.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  PostServices postServices = PostServices();
  final commentsRef = FirebaseFirestore.instance.collection('comments');

  void postButton() {
    if (commentController.text.isNotEmpty) {
      String comment = commentController.text;
      commentController.clear();
      postServices.addComment(comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color(0xfffafafa),
        title: Text('Comments', style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                commentWidget(
                  postCaption: Data._currentPost.caption,
                  postName: Data._currentPost.name,
                    timestamp: Data._currentPost.timestamp,
                    postPhotoUrl: Data._currentPost.publisherProfilePhotoUrl
                ),
                Divider(
                  thickness: 0.2,
                  color: Colors.black,
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: commentsRef
                  .doc(Data._currentPost.postId)
                  .collection('postComments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final List<Widget> comments =
                    snapshot.data.docs.map((comment) {
                  print('comment[\'userName\']  is ${comment['userName']}');
                  print(
                      'comment[\'userComment\']  is ${comment['userComment']}');
                  return commentWidget(
                    postName: comment['userName'],
                    postCaption: comment['userComment'],
                    timestamp: comment['timestamp'],
                    postPhotoUrl: comment['userPhotoUrl']
                  );
                }).toList();

                print('comments.length is ${comments.length}');
                print('snapshot.data.documents is ${snapshot.data.docs}');

                return ListView.builder(
                  itemBuilder: (context, index) => comments[index],
                  shrinkWrap: true,
                  itemCount: comments.length,
                );
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    icon: Data.defaultUser.photoUrl == ''
                        ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                        : CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xffFDCF09),
                      child: CircleAvatar(
                          radius: 50, backgroundImage: NetworkImage(Data.defaultUser.photoUrl)),
                    ),
                    suffixIcon: FlatButton(
                      child: Text('Post'),
                      onPressed: postButton,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
