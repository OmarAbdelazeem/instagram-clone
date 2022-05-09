import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/profile_photo.dart';

class CommentView extends StatelessWidget {
  final CommentModel comment;
  final bool isUploaded;

  CommentView({required this.comment, this.isUploaded = true});

  @override
  Widget build(BuildContext context) {
    print("isUploaded is $isUploaded");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildUpperPartView(),
        SizedBox(
          height: 5,
        ),
        // _buildTimestampView()
        !isUploaded ? _buildTimestampView() : Text("Posting"),
      ],
    );
  }

  Text _buildTimestampView() {
    return Text(
      timeago.format(comment.timestamp),
      style: TextStyle(fontSize: 11, color: Colors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _buildUpperPartView() {
    return Row(
      children: <Widget>[
        ProfilePhoto(photoUrl: comment.publisherPhotoUrl, radius: 20),
        SizedBox(
          width: 10,
        ),
        Text(
          comment.publisherName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          comment.comment,
        )
      ],
    );
  }
}
