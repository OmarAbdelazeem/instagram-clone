import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';

import '../../../models/notification_model/notification_model.dart';
import 'widgets/notification_item.dart';

class ActivityScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(NotificationModel(
        notificationTypeNum: 0,
        comment: "test",
        senderId: "1",
        ownerName: "test",
        postId: "2",
        postUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        timestamp: (Timestamp.now()).toDate(),
        userPhotoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg")),
    NotificationItem(NotificationModel(
        notificationTypeNum: 2,
        comment: "test",
        senderId: "1",
        ownerName: "test",
        postId: "1",
        postUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        timestamp: (Timestamp.now()).toDate(),
        userPhotoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNotifications(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.activity,
        style: AppTextStyles.appBarTitleStyle,
      ),
    );
  }

  Widget _buildNotifications() {
    return ListView.builder(
      itemBuilder: (context, index) => notifications[index],
      shrinkWrap: true,
      itemCount: notifications.length,
    );
  }
}
