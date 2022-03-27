import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/profile_photo.dart';

class CommentWidget extends StatelessWidget {
  final String postName;
  final String postCaption;
  final String postPhotoUrl;
  final Timestamp timestamp;

  CommentWidget(
      {required this.postName,
      required this.postCaption,
      required this.postPhotoUrl,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget commentWidget(
    {required String postName,
    required String postCaption,
    required String postPhotoUrl,
    required Timestamp timestamp}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: ProfilePhoto(postPhotoUrl),
              height: 50,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                postName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Text(
                postCaption,
              ),
            ),
          ],
        ),
        Text(
          timeago.format(timestamp.toDate()),
          style: TextStyle(fontSize: 11, color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
