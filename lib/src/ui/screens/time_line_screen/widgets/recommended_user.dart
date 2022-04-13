import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/my_profile_screen.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/searched_user_profile_screen.dart';

import '../../../../models/user_model/user_model.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';

class RecommendedUser extends StatefulWidget {
  final UserModel user;

  RecommendedUser(this.user);

  @override
  _RecommendedUserState createState() => _RecommendedUserState();
}

class _RecommendedUserState extends State<RecommendedUser> {
  bool isFollowing = false;

  void onFollowButtonTapped() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => SearchedUserProfileScreen(
        //         userId: widget.user.id, userName: widget.user.userName),
        //   ),
        // );
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfilePhoto(
                photoUrl: widget.user.photoUrl,
                radius: 24,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.user.userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.user.bio,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              _buildFollowButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    return AppButton(
      height: 40,
      width: 120,
      color: isFollowing ? AppColors.white : AppColors.blue,
      titleStyle: TextStyle(
        color: isFollowing ? AppColors.black : AppColors.white,
      ),
      title: isFollowing ? AppStrings.following : AppStrings.follow,
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
    );
  }
}
