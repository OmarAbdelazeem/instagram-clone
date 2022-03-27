import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/post_widget.dart';

class UserMentionedPostsView extends StatelessWidget {


  const UserMentionedPostsView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     List<PostModel> posts =[];
    return posts.length == 0
        ? _buildEmptyMentionedPhotos()
        : ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return PostWidget(post: posts[index]);
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
