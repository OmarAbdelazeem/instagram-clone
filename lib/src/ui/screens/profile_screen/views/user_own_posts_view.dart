import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_strings.dart';

import '../../../common/post_widget.dart';

class UserOwnPostsView extends StatelessWidget {

  const UserOwnPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts =[];
    return posts.length == 0
        ? _buildEmptyOwnPosts()
        : GridView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
                mainAxisSpacing: 3),
            itemBuilder: (context, index) {
              return PostWidget(post: posts[index]);
            },
          );
  }

  Widget _buildEmptyOwnPosts() {
    return Column(
      children: <Widget>[
        Text(
          AppStrings.profile,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          AppStrings.whenYouSharePhotosAndVideosTheyWillAppear,
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            AppStrings.shareYourFirstPhotoOrVideo,
            style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
