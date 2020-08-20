import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';
import 'package:instagramapp/services/profile_service.dart';

class FollowerOrFollowingWidget extends StatefulWidget {
   bool isFollowing;
   User user;
  FollowerOrFollowingWidget({this.isFollowing=true,this.user});

  @override
  _FollowerOrFollowingWidgetState createState() => _FollowerOrFollowingWidgetState();
}

class _FollowerOrFollowingWidgetState extends State<FollowerOrFollowingWidget> {
  ProfileService profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    void followButton() {
      Data.changeCurrentUser(widget.user);
      setState(() {
        widget.isFollowing = true;
      });
      profileService.followingOperation();
    }

    void unFollowButton() async{

      Data.changeCurrentUser(widget.user);
      setState(() {
        widget.isFollowing = false;
      });
      await profileService.unFollowOperation();
//      await profileService.unFollowWithoutDelete();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: userProfilePhoto(photoUrl: widget.user.photoUrl),
                width: 50,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.user.userName),
              )
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: RaisedButton(
                color: !widget.isFollowing ? Colors.blue : Colors.white,
                onPressed: widget.isFollowing ? unFollowButton : followButton,
                child: !widget.isFollowing
                    ? Text(
                  'Follow',
                  style: TextStyle(color: Colors.white),
                )
                    : Text('Following'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Widget followerOrFollowingWidget({bool isFollowing, User user}) {
//  void followButton() {
//    profileService.changeNeededUser(user);
//    setState(() {
//      isFollowing = true;
//    });
//    profileService.followingOperation();
//  }
//
//  void unFollowButton() {
//    profileService.changeNeededUser(user);
//    setState(() {
//      isFollowing = false;
//    });
//    profileService.unFollowOperation();
//  }
//
//  return Padding(
//    padding: const EdgeInsets.all(8.0),
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Row(
//          children: <Widget>[
//            Container(
//              child: userProfilePhoto(photoUrl: user.photoUrl),
//              width: 50,
//              height: 50,
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(user.userName),
//            )
//          ],
//        ),
//        GestureDetector(
//          onTap: () {},
//          child: Container(
//            width: MediaQuery.of(context).size.width * 0.25,
//            child: RaisedButton(
//              color: !isFollowing ? Colors.blue : Colors.white,
//              onPressed: isFollowing ? unFollowButton : followButton,
//              child: !isFollowing
//                  ? Text(
//                'Follow',
//                style: TextStyle(color: Colors.white),
//              )
//                  : Text('Following'),
//            ),
//          ),
//        ),
//      ],
//    ),
//  );
//}