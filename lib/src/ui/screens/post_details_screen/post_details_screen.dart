import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';

import '../../../models/viewed_post_model/viewed_post_model.dart';
import '../../common/post_view.dart';

class PostDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: _buildAppBar(),
      body: PostView(
        post: post,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.post,
        style: AppTextStyles.appBarTitleStyle
      ),
    );
  }
}
