import 'package:flutter/material.dart';

Widget noMentionedPhotos() {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(10),
    child: Column(
      children: <Widget>[
        Text(
          'Photos and Videos of You',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'when people tag you in photos and videos,they\'ll appear here',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
      ],
    ),
  );
}