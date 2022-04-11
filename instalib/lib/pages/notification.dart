import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/notification.dart';
import 'package:instagramapp/services/auth.dart';
import 'package:instagramapp/widgets/notification_item_widget.dart';

class ActivityFeed extends StatelessWidget {
//  final GlobalKey<ScaffoldState> navigatorKey;
//
//  ActivityFeed({this.navigatorKey});

  final notificationRef = FirebaseFirestore.instance.collection('notification');

  @override
  Widget build(BuildContext context) {
    return Navigator(
//      key: navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xfffafafa),
                  automaticallyImplyLeading: false,
                  title: Text('Activity',style: TextStyle(color: Colors.black),),
                ),
                body: StreamBuilder<QuerySnapshot>(
                  stream: notificationRef
                      .doc(Data.defaultUser.searchedUserId)
                      .collection('userNotification')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    List<NotificationItemWidget> notifications =
                        snapshot.data.docs.map((notificationDoc) {
                      SingleNotification notification =
                          SingleNotification.fromDoc(notificationDoc);
                      if (notification.type == 'comment')
                        return NotificationItemWidget(
                            notification: notification, isComment: true);
                      else if (notification.type == 'like')
                        return NotificationItemWidget(
                            notification: notification, isLike: true);

                      return NotificationItemWidget(
                          notification: notification, isFollow: true);
                    }).toList();

// ignore: missing_return
                    print(notifications);
                    return ListView.builder(
                      itemBuilder: (context, index) => notifications[index],
                      shrinkWrap: true,
                      itemCount: notifications.length,
                    );
                  },
                ),
              )),
    );
  }
}
