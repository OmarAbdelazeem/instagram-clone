import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/comment_model/comment_model.dart';

import '../../../common/profile_photo.dart';
import '../../../common/timestamp_view.dart';

class CommentView extends StatelessWidget {
  final CommentModel comment;
  final bool isUploaded;

  CommentView({required this.comment, this.isUploaded = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUpperPartView(),
          SizedBox(
            height: 5,
          ),
          !isUploaded ? TimeStampView(comment.timestamp) : Text("Posting"),
          SizedBox(
            height: 12,
          ),
        ],
      ),
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
