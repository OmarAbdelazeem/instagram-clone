import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_strings.dart';

import '../../common/post_widget.dart';

class PostDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;
    return Scaffold(
      // drawerScrimColor: Colors.black,
      appBar: _buildAppBar(),
      body: PostWidget(
        post: post,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      // backgroundColor: Color(0xfffafafa),
      title: Text(
        AppStrings.post,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
