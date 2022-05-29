import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/common/small_post_view.dart';

import '../../models/post_model/post_model.dart';

class SmallPostsGridView extends StatelessWidget {
  final List<PostModel> posts;
  SmallPostsGridView(this.posts);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        mainAxisExtent: 120,
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return SmallPostView(post: posts[index]);
      },
    );
  }
}


