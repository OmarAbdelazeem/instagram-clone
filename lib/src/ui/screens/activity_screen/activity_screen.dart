import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_strings.dart';

import '../../../models/notification_model/notification_model.dart';
import 'widgets/notification_item.dart';

class ActivityScreen extends StatelessWidget {
 final List<NotificationItem> notifications = [
    NotificationItem(
        notification: NotificationModel(
            comment: "test",
            ownerId: "1",
            ownerName: "test",
            postId: "1",
            postUrl: "adf",
            timestamp: "af",
            userPhotoUrl: ""),
        isComment: true),
    NotificationItem(
        notification: NotificationModel(
            comment: "test",
            ownerId: "1",
            ownerName: "test",
            postId: "1",
            postUrl: "adf",
            timestamp: "af",
            userPhotoUrl: ""),
        isComment: true)
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNotifications(),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        AppStrings.activity,
      ),
    );
  }

  Widget _buildNotifications(){
    return ListView.builder(
      itemBuilder: (context, index) => notifications[index],
      shrinkWrap: true,
      itemCount: notifications.length,
    );
  }
}
