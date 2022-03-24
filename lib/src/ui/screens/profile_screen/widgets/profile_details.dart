import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';

import '../../../../res/app_strings.dart';

class ProfileDetails extends StatelessWidget {
  final UserModel user;
  final bool isMyProfile;

  const ProfileDetails({Key? key, required this.user, this.isMyProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        _buildPhotoWithNumericDetails(context),
        SizedBox(
          height: 10,
        ),
        _buildBio()
      ],
    );
  }

  Padding _buildBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            isMyProfile ? user.userName : user.userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          isMyProfile ? Text(user.bio) : Text(user.bio),
        ],
      ),
    );
  }

  Row _buildPhotoWithNumericDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        isMyProfile
            ? _buildLoggedInUserProfilePhoto(user.photoUrl)
            : _buildSearchedUserProfilePhoto(user.photoUrl),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildNumericInfo(user.postsCount, AppStrings.posts),
              _buildNumericInfo(user.followingCount, AppStrings.followers),
              _buildNumericInfo(user.followingCount, AppStrings.following),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildNumericInfo(int count, String name) {
  return Column(
    children: <Widget>[
      Text(
        '$count',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        name,
        style: TextStyle(fontSize: 15),
      )
    ],
  );
}

Widget _buildSearchedUserProfilePhoto(String photoUrl) {
  return photoUrl.isNotEmpty
      ? Container(
          height: 85,
          width: 85,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffFDCF09),
            child: CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(photoUrl)),
          ),
        )
      : Container(
          height: 85,
          width: 85,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person_outline,
              size: 40,
              color: Colors.white,
            ),
          ),
        );
}

Widget _buildLoggedInUserProfilePhoto(String photoUrl) {
  return Container(
    height: 85,
    width: 85,
    child: Stack(
      children: <Widget>[
        Container(
          height: 80,
          width: 80,
          child: photoUrl.isNotEmpty
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffFDCF09),
                  child: CircleAvatar(
                      radius: 50, backgroundImage: NetworkImage(photoUrl)),
                )
              : CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_outline,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
        ),
        Positioned(
          child: Icon(
            Icons.add_circle,
            color: Colors.blue,
          ),
          right: 0,
          bottom: 0,
        ),
      ],
    ),
  );
}
