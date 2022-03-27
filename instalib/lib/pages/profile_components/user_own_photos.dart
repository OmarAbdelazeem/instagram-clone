import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:instagramapp/widgets/single_photo_of_grid.dart';

Widget userOwnPhotos(String id) {
  ProfileService profileService = ProfileService();
  final postsRef = FirebaseFirestore.instance.collection('posts');

  return StreamBuilder<QuerySnapshot>(
    stream: postsRef.doc(id).collection('userPosts').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
//        print('id from user own photos $id');
        print('!snapshot.hasData is $snapshot');

        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        print('snapshot.error is ${snapshot.error}');
      }

      print('snapshot.data is $snapshot');
      List<PostPhoto> posts =
      snapshot.data.docs.map(
        (post) {
          return PostPhoto(
            post: Post.fromDocument(post),
          );
        },
      ).toList();
      print('posts is $posts');
      return posts.length == 0
          ? noOwnPhotos()
          : GridView.builder(
              shrinkWrap: true,
              itemCount: posts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 6, childAspectRatio: 1,mainAxisSpacing: 3),
              itemBuilder: (context, index) {
                return posts[index];
              },
            );
    },
  );
}

Widget noOwnPhotos() {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        Text(
          'Profile',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'when you share photos and videos,they will appear on your profile',
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
            'Share your first photo or video',
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}