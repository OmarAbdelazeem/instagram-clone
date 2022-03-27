import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/post_widget.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/way_of_view_tabs.dart';
import '../../../../router.dart';
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
              _buildEditProfileButton(),
              SizedBox(
                height: 10,
              ),
              WayOfViewTabs()
            ],
          ),
          // isOwnPosts ? userOwnPhotos(posts) : noMentionedPhotos()
        ],
      ),
    );
  }

  Padding _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AppButton(
        onTap: () {
          NavigationUtils.pushNamed(
              route: AppRoutes.editProfileScreen, context: context);
        },
        borderColor: AppColors.grey.shade500,
        height: 35,
        title: AppStrings.editProfile,
        color: AppColors.white,
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        disabledColor: AppColors.scaffoldBackgroundColor,
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

  void editProfile() {}
}
