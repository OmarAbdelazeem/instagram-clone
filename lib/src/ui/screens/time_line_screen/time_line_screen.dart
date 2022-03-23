import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../models/user_model/user_model.dart';
import '../../common/app_logo.dart';
import '../../common/post_widget.dart';

class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  List<PostWidget> posts = [];

  _buildTimelinePosts(List<PostWidget> posts) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => posts[index],
      itemCount: posts.length,
    );
  }

//   _buildUsersToFollow(List<UserModel> users) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       width: double.infinity,
//       child: Column(
// //          mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             AppStrings.welcomeToInstagram,
//             style: TextStyle(
//               fontSize: 30,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             AppStrings.followPeopleToStartSeeingPhotos,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 17,
//             ),
//           ),
//           Container(
//             height: 300,
//             child: ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return users[index];
//               },
//               itemCount: users.length,
//             ),
//           ),
//         ],
//       ),
//     );
//
//     // return ListView(
//     //   children: <Widget>[
//     //     StreamBuilder(
//     //       stream: usersRef
//     //           .orderBy('timestamp', descending: true)
//     //           .limit(30)
//     //           .snapshots(),
//     //       builder: (context, snapshot) {
//     //         if (!snapshot.hasData) {
//     //           return CircularProgressIndicator();
//     //         }
//     //         List<RecommendedUser> userRecommends = [];
//     //         snapshot.data.documents.forEach((doc) {
//     //           UserModel user = UserModel.fromDocument(doc);
//     //           final bool isAuthUser = Data.defaultUser.id == user.id;
//     //           final bool isFollowingUser = followingList.contains(user.id);
//     //           // remove auth user from recommended list
//     //           if (isAuthUser) {
//     //             return;
//     //           } else if (isFollowingUser) {
//     //             return;
//     //           } else {
//     //             RecommendedUser userResult = RecommendedUser(user);
//     //             userRecommends.add(userResult);
//     //           }
//     //         });
//     //
//     //       },
//     //     )
//     //   ],
//     // );
//   }

  @override
  void initState() {
    // TODO: implement initState
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
      // title: AppLogo(),
      actions: <Widget>[
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
}
