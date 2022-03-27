import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/notification_model/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../enums/notification_type.dart';
import '../../../../res/app_strings.dart';
import '../../../common/profile_photo.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  NotificationItem(this.notification);

  void onUserClicked(BuildContext context) {
    // ProfileService profileService = ProfileService();
    // profileService.getProfileMainInfo(id: notification.ownerId).then((user){
    //   Data.changeCurrentUser(user);
    //   NavigationFunctions.navigateToPage(context, UserProfile());
    // });
  }

  void onPostClicked(BuildContext context) {
    // print('post id is ${notification.postId}');
    // PostServices postServices = PostServices();
    // postServices.getPostInfo(postId: notification.postId).then((post){
    //   Data.changeCurrentPost(post);
    //   NavigationFunctions.navigateToPage(context, PostScreen(post: post,));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onUserClicked(context);
            },
            child: Container(
                height: 55,
                width: 55,
                child: ProfilePhoto(notification.userPhotoUrl)),
          ),
          GestureDetector(
            onTap: () {
              if (isPost) onPostClicked(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '${notification.ownerName} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getNotificationStatement(),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      height: 18,
                      alignment: Alignment.topLeft,
                      child: Text(
                        // timeago.format(notification.timestamp.toDate()),
                        notification.timestamp,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          notification.notificationTypeNum == NotificationType.like.index ||
                  notification.notificationTypeNum ==
                      NotificationType.comment.index
              ? _buildPostView(context)
              : Container(),
        ],
      ),
    );
  }

  Widget _buildPostView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPostClicked(context);
      },
      child: Container(
        width: 50,
        height: 50,
        child: Image.network(
          notification.postUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String getNotificationStatement() {
    if (notification.notificationTypeNum == NotificationType.like.index) {
      return AppStrings.likedYourPhoto;
    } else if (notification.notificationTypeNum ==
        NotificationType.comment.index) {
      return AppStrings.commentedOnYourPost;
    } else {
      return AppStrings.startedFollowingYou;
    }
  }
}
