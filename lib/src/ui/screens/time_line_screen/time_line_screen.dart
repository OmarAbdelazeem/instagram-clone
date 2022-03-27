import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/app_drop_down_button.dart';
import 'package:instagramapp/src/ui/screens/time_line_screen/widgets/recommended_user.dart';
import '../../../../router.dart';
import '../../../bloc/time_line_bloc/time_line_bloc.dart';
import '../../../models/user_model/user_model.dart';
import '../../../res/app_strings.dart';
import '../../common/app_logo.dart';
import '../../common/post_widget.dart';

class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  List<PostWidget> posts = [
    PostWidget(
      post: PostModel(
          timestamp: DateTime.now(),
          postId: "1",
          caption: "test",
          likesCount: 12,
          photoUrl:
              "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
          publisherId: "12",
          publisherName: "Omar",
          publisherProfilePhotoUrl:
              "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg"),
    )
  ];

  List<UserModel> users = [
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: "546843"),
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: "546843"),
    UserModel(
        photoUrl:
            "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
        userName: "Omar Abdelazeem",
        bio: "this is a bio",
        id: "123",
        email: "omar@email.com",
        postsCount: 1,
        followersCount: 3,
        followingCount: 5,
        timestamp: "546843"),
  ];

  @override
  void initState() {
    getTimeLinePosts();
    context.read<TimeLineBloc>().add(TimeLineLoadStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () => getTimeLinePosts(),
        child: _buildTimelinePosts(posts),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: AppLogo(),
      actions: <Widget>[
        AppDropDownButton(),
        SizedBox(
          width: 12,
        ),
        IconButton(
          onPressed: () {
            NavigationUtils.pushNamed(
                route: AppRoutes.activityScreen, context: context);
          },
          icon: Icon(Icons.favorite_outline),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppImages.sendButtonSvg,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }

  getTimeLinePosts() {}

  _buildTimelinePosts(List<PostWidget> posts) {
    return posts.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => posts[index],
            itemCount: posts.length,
          )
        : _buildRecommendedUsers(users);
  }

  _buildRecommendedUsers(List<UserModel> users) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppStrings.welcomeToInstagram,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            AppStrings.followPeopleToStartSeeingPhotos,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return RecommendedUser(users[index]);
              },
              itemCount: users.length,
            ),
          ),
        ],
      ),
    );
  }
}
