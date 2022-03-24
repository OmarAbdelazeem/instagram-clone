import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../common/post_widget.dart';


Widget userOwnPhotos(List<PostWidget> posts) {
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