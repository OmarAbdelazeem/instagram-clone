import 'package:flutter/material.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/post_widget.dart';
import 'widgets/profile_details.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user = UserModel(
      photoUrl:
          "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
      userName: "Omar Abdelazeem",
      bio: "this is a bio",
      id: "123",
      email: "omar@email.com",
      postsCount: 1,
      followersCount: 3,
      followingCount: 5,
      timestamp: "546843");
  List<PostWidget> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // setProfileInfo();
      },
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              ProfileDetails(user: user),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: AppButton(
                  borderColor: AppColors.grey.shade500,
                  height: 35,
                  title: AppStrings.editProfile,
                  color: AppColors.white,
                  titleStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  disabledColor: AppColors.scaffoldBackgroundColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTabsView(context)
            ],
          ),
          // isOwnPosts ? userOwnPhotos(posts) : noMentionedPhotos()
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        user.userName,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTabsView(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.grid_on,
                    color: Colors.black87,
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black87,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Colors.black87,
                  ),
                  Divider(
                    thickness: 1.5,
                    color: Colors.black87,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editProfile() {}
}
