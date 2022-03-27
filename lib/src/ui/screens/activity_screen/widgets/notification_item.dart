import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/notification_model/notification_model.dart';
import 'package:instagramapp/src/ui/screens/searched_post_screen/searched_post_screen.dart';
import 'package:instagramapp/src/ui/screens/searched_user_profile/searched_user_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../router.dart';
import '../../../../enums/notification_type.dart';
import '../../../../res/app_strings.dart';
import '../../../common/profile_photo.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  NotificationItem(this.notification);

  bool? isNotNewFollower;

  void onUserProfilePhotoTapped(BuildContext context) {
    NavigationUtils.pushScreen(
        screen: SearchedUserProfileScreen(notification.senderId),
        context: context);
  }

  void onPostItemClicked(BuildContext context) {
    NavigationUtils.pushScreen(
        screen: SearchedPostScreen(
            postId: notification.postId, userId: notification.senderId),
        context: context);
  }

  void onNotificationTapped(BuildContext context) {
    if (isNotNewFollower!) {
      onPostItemClicked(context);
    } else {
      onUserProfilePhotoTapped(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    isNotNewFollower =
        notification.notificationTypeNum != NotificationType.follow.index ||
            notification.notificationTypeNum == NotificationType.comment.index;
    return GestureDetector(
      onTap: () => onNotificationTapped(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPhotoWithNotificationStatement(context),
            isNotNewFollower! ? _buildPostView(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoWithNotificationStatement(BuildContext context) {
    return Row(
      children: [
        _buildProfilePhotoView(context),
        SizedBox(
          width: 12,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    _getNotificationStatement(),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                // timeago.format(notification.timestamp.toDate()),
                notification.timestamp,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildProfilePhotoView(BuildContext context) {
    return GestureDetector(
      onTap: () => onUserProfilePhotoTapped(context),
      child: Container(
          height: 55,
          width: 55,
          child: ProfilePhoto(photoUrl: notification.userPhotoUrl,)),
    );
  }

  Widget _buildPostView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPostItemClicked(context);
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

  String _getNotificationStatement() {
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
