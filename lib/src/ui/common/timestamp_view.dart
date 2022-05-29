import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeStampView extends StatelessWidget {
  final DateTime timestamp;

  TimeStampView(this.timestamp);

  @override
  Widget build(BuildContext context) {
    return Text(
      timeago.format(timestamp),
      style: TextStyle(fontSize: 11, color: Colors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }
}
