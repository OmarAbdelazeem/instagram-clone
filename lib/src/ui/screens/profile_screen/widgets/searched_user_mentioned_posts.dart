import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/searched_user_empty_posts.dart';

import '../../../../models/post_model/post_model_response/post_model_response.dart';
import '../../../common/post_view.dart';


class SearchedUserMentionedPostsView extends StatelessWidget {
  final String userId;

  const SearchedUserMentionedPostsView({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostModelResponse> posts = [];
    return posts.length == 0
        ? Center(child: SearchedUserEmptyPostsView())
        : ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return PostView(
          post: posts[index],
        );
      },
    );
  }
}

