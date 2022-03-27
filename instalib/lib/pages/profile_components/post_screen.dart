import 'package:flutter/material.dart';
import 'package:instagramapp/widgets/post_widget.dart';

class PostScreen extends StatelessWidget {
  final post;

  PostScreen({this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color(0xfffafafa),
        title: Text(
          'Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: PostWidget(
        post: post,
      ),
    );
  }
}
