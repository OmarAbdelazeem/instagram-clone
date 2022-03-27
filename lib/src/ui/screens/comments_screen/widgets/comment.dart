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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildUpperPartView(),
        SizedBox(height: 5,),
        _buildTimestampView(),
      ],
    );
  }

  Text _buildTimestampView() {
    return Text(
      timeago.format(timestamp.toDate()),
      style: TextStyle(fontSize: 11, color: Colors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _buildUpperPartView() {
    return Row(
      children: <Widget>[
        ProfilePhoto(photoUrl: postPhotoUrl, radius: 20),
        SizedBox(
          width: 10,
        ),
        Text(
          postName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          postCaption,
        )
      ],
    );
  }
}
