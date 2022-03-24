import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_strings.dart';

import '../../common/post_widget.dart';

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
          AppStrings.post,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: PostWidget(
        post: post,
      ),
    );
  }
}
