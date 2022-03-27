import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/widgets/comment.dart';


class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();

  // PostServices postServices = PostServices();
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  List<CommentWidget> comments = [CommentWidget(
    postCaption: "test",
    postName: "test",
    postPhotoUrl: "test",
    timestamp: Timestamp.now(),)
  ];

  void postButton() {
    // if (commentController.text.isNotEmpty) {
    //   String comment = commentController.text;
    //   commentController.clear();
    //   postServices.addComment(comment);
    // }
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

                // commentWidget(
                //   postCaption: Data.currentPost.caption,
                //   postName: Data.currentPost.name,
                //     timestamp: Data.currentPost.timestamp,
                //     postPhotoUrl: Data.currentPost.publisherProfilePhotoUrl
                // ),
                Divider(
                  thickness: 0.2,
                  color: Colors.black,
                )
              ],
            ),
            ListView.builder(
              itemBuilder: (context, index) => comments[index],
              shrinkWrap: true,
              itemCount: comments.length,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    icon: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.white,
                      ),
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
