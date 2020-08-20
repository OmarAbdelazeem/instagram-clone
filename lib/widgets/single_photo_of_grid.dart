import 'package:flutter/material.dart';
import 'package:instagramapp/pages/profile_components/post_screen.dart';

class PostPhoto extends StatelessWidget {
  final post;

  PostPhoto({this.post});

  @override
  Widget build(BuildContext context) {
    print('post.url is ${post.photoUrl}');
    return Container(
      height: 100,
      width: 70,
      color: Colors.grey,
      child: GestureDetector(
        onTap: () {
          print('post was clicked');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostScreen(
                      post: post,
                      ),
              ),
          );
        },
        child: Image.network(
          post.photoUrl,
        ),
      ),
    );
  }
}
