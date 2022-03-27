import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/widgets/comment.dart';

import '../../../res/app_strings.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  List<CommentWidget> comments = [
    CommentWidget(
      postCaption: "test",
      postName: "test",
      postPhotoUrl:
          "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
      timestamp: Timestamp.now(),
    )
  ];

  void onPostButtonTapped() {
    if (commentController.text.isNotEmpty) {
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: double.infinity,
        child: Column(
          children: <Widget>[
            _buildPostCaption(),
            Expanded(child: _buildComments()),
            _buildCommentTextField()
          ],
        ),
      ),
    );
  }

  Column _buildPostCaption() {
    return Column(
      children: <Widget>[
        CommentWidget(
          postCaption: "test",
          postName: "test",
          postPhotoUrl:
              "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
          timestamp: Timestamp.now(),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.black,
        )
      ],
    );
  }

  ListView _buildComments() {
    return ListView.builder(
      itemBuilder: (context, index) => comments[index],
      itemCount: comments.length,
    );
  }

  Widget _buildCommentTextField() {
    return AppTextField(
      controller: commentController,
      icon: ProfilePhoto(radius: 20),
      suffixIcon: TextButton(
          child:
              Text(AppStrings.post, style: TextStyle(color: AppColors.black)),
          onPressed: onPostButtonTapped),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.comments,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        Icon(Icons.more_vert),
      ],
    );
  }
}
