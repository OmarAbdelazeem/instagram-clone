import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget commentWidget(
    {String postName, String postCaption, String postPhotoUrl,Timestamp timestamp}) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: userProfilePhoto(photoUrl: postPhotoUrl),
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
            style: TextStyle(fontSize: 11,color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
