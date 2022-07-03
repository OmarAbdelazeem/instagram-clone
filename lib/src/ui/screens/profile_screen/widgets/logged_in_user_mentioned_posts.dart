import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/logged_in_user_empty_mentioned_photos.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/searched_user_empty_posts.dart';

import '../../../../models/post_model/post_model_response/post_model_response.dart';
import '../../../common/post_view.dart';


class LoggedInUserMentionedPostsView extends StatelessWidget {
  final String userId;

  const LoggedInUserMentionedPostsView({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostModelResponse> posts = [];
    return posts.length == 0
        ? LoggedInUserEmptyMentionedPhotos()
        : ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return PostView(
          post: posts[index],
        );
      },
    );
  }
}

