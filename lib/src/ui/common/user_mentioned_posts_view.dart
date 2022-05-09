import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'post_view.dart';

class UserMentionedPostsView extends StatelessWidget {
  final String userId;

  const UserMentionedPostsView({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = [];
    return posts.length == 0
        ? _buildEmptyMentionedPhotos()
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return PostView(
                post: posts[index],
              );
            },
          );
  }
}

Widget _buildEmptyMentionedPhotos() {
  return Column(
    children: <Widget>[
      Text(
        AppStrings.photosAndVideosOfYou,
        style: TextStyle(fontSize: 30),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        AppStrings.whenPeopleTagYouIn,
        style: TextStyle(fontSize: 16),
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 15,
      ),
    ],
  );
}
