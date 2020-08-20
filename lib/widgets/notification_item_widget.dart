import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/notification.dart';
import 'package:instagramapp/pages/profile_components/post_screen.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';
import 'package:instagramapp/pages/user_profile.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/posts_service.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItemWidget extends StatelessWidget {
  final SingleNotification notification;
  final bool isComment;

  final bool isLike;

  final bool isFollow;

  NotificationItemWidget(
      {this.notification,
      this.isComment = false,
      this.isFollow = false,
      this.isLike = false});

  void onUserClicked(BuildContext context){
    ProfileService profileService = ProfileService();
    profileService.getProfileMainInfo(id: notification.ownerId).then((user){
      Data.changeCurrentUser(user);
      NavigationFunctions.navigateToPage(context, UserProfile());
    });
  }
  void onPostClicked(BuildContext context){
    print('post id is ${notification.postId}');
    PostServices postServices = PostServices();
    postServices.getPostInfo(postId: notification.postId).then((post){
      Data.changeCurrentPost(post);
      NavigationFunctions.navigateToPage(context, PostScreen(post: post,));
    });

  }
  @override
  Widget build(BuildContext context) {
    bool isPost = (isLike || isComment);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 10),
      child: GestureDetector(
        onTap: (){
          isFollow ? onUserClicked(context) : null ;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                onUserClicked(context);
              },
              child: Container(
                  height: 55,
                  width: 55,
                  child: userProfilePhoto(photoUrl: notification.userPhotoUrl)),
            ),
            GestureDetector(
              onTap: (){
               isPost ? onPostClicked(context) : null ;
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
//            height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
//                      SizedBox(width: 5,),
                        Text(
                          '${notification.ownerName} ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
//                  overflow: TextOverflow.clip,
                        ),
                        isComment
                            ? Container(
//                  width: 160,
                                child: Text(
                                  'commented on your post',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                ),
                              )
                            : Container(),
                        isLike
                            ? Text(
                                'liked your photo',
                              )
                            : Container(),
                        isFollow
                            ? Text(
                                'started following you',
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 18,
                        alignment: Alignment.topLeft,
//                  padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          timeago.format(notification.timestamp.toDate()),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isPost
                ? GestureDetector(
              onTap: (){
                onPostClicked(context);
              },
                  child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            notification.postUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}

//isComment
//
