import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/searched_user_empty_posts.dart';
import '../../../../bloc/post_item_bloc/post_item_bloc.dart';
import '../../../../models/post_model/post_model.dart';
import '../../../../repository/data_repository.dart';
import '../../../../repository/posts_repository.dart';
import '../../../common/post_view.dart';

class SearchedUserMentionedPostsView extends StatelessWidget {
  final String userId;

  const SearchedUserMentionedPostsView({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = [];
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
