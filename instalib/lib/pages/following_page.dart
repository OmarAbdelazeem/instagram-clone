import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/user_profile.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:instagramapp/widgets/follower_or_following_widget.dart';


class FollowingPage extends StatefulWidget {

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> with AutomaticKeepAliveClientMixin<FollowingPage>{
  ProfileService profileService = ProfileService();
  List followingUsers = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  bool get wantKeepAlive =>true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot>(
      future: profileService.getFollowingUsers(isMyProfile:true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('!snapshot.hasData is $snapshot');

          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('snapshot.error is ${snapshot.error}');
        }

        followingUsers = snapshot.data.docs.map((doc) {
          return GestureDetector(
            onTap: () {
              Data.changeCurrentUser(UserModel.fromDocument(doc));
              NavigationFunctions.navigateToPage(context, UserProfile());
            },
            child: FollowerOrFollowingWidget(
              isFollowing: doc['isFollowing'],
              data: UserModel.fromDocument(doc),
            )
          );
        }).toList();
        return ListView.builder(
          itemBuilder: (context, index) {
            return followingUsers[index];
          },
          itemCount: followingUsers.length,
          shrinkWrap: true,
        );
      },
    );
  }
}
