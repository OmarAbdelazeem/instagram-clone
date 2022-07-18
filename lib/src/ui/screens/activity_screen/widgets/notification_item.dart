import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../models/notification_model/notification_model.dart';
import '../../../../res/app_strings.dart';
import '../../../common/profile_photo.dart';
import '../../profile_screen/searched_user_profile_screen.dart';
import '../../searched_post_screen/post_from_notification_screen.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  NotificationItem(this.notification);

  void onUserProfilePhotoTapped(BuildContext context) {
    NavigationUtils.pushScreen(
        screen: SearchedUserProfileScreen(
          user: notification.user!,
        ),
        context: context);
  }

  void onPostPhotoClicked(BuildContext context) {
    NavigationUtils.pushScreen(
        screen: PostFromNotificationScreen(postId: notification.postId!),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return _getCorrectView(context);
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
                    '${notification.user!.userName!} ',
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
                timeago.format(notification.timestamp),
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
      child: ProfilePhoto(
        photoUrl: notification.user!.photoUrl!,
      ),
    );
  }

  Widget _buildPostView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPostPhotoClicked(context);
      },
      child: Container(
        width: 50,
        height: 50,
        child: Image.network(
          notification.post!.photoUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String _getNotificationStatement() {
    switch (notification.type) {
      case "1":
        return AppStrings.startedFollowingYou;
      case "2":
        return AppStrings.likedYourPhoto;
      case "3":
        return AppStrings.commentedOnYourPost;
    }
    return "Unknown";
  }

  Widget _getCorrectView(BuildContext context) {
    switch (notification.type) {
      case "1":
        return _buildFollowView(context);
      case "2":
        return _buildLikeView(context);
      case "3":
        return _buildCommentView(context);
    }

    return Container();
  }

  Widget _buildFollowView(BuildContext context) {
    return GestureDetector(
      onTap: () => onUserProfilePhotoTapped(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: _buildPhotoWithNotificationStatement(context),
      ),
    );
  }

  Widget _buildCommentView(BuildContext context) {
    return GestureDetector(
      onTap: () => onPostPhotoClicked(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPhotoWithNotificationStatement(context),
            _buildPostView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeView(BuildContext context) {
    return GestureDetector(
      onTap: () => onPostPhotoClicked(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPhotoWithNotificationStatement(context),
            _buildPostView(context),
          ],
        ),
      ),
    );
  }
}
