import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../common/app_logo.dart';
import '../../common/post_widget.dart';


class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  //  AuthService _auth = AuthService();
  List<PostWidget> posts = [];
  PostServices postServices = PostServices();
  bool postLoaded = false;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final followingRef = FirebaseFirestore.instance.collection('following');

  List<String> followingList = [];

  _buildTimelinePosts() {
    if (posts.isEmpty) {
      return _buildUsersToFollow();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => posts[index],
        itemCount: posts.length,
      );
    }
  }

  _buildUsersToFollow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
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
                return userRecommends[index];
              },
              itemCount: userRecommends.length,
            ),
          ),
        ],
      ),
    );

    // return ListView(
    //   children: <Widget>[
    //     StreamBuilder(
    //       stream: usersRef
    //           .orderBy('timestamp', descending: true)
    //           .limit(30)
    //           .snapshots(),
    //       builder: (context, snapshot) {
    //         if (!snapshot.hasData) {
    //           return CircularProgressIndicator();
    //         }
    //         List<RecommendedUser> userRecommends = [];
    //         snapshot.data.documents.forEach((doc) {
    //           UserModel user = UserModel.fromDocument(doc);
    //           final bool isAuthUser = Data.defaultUser.id == user.id;
    //           final bool isFollowingUser = followingList.contains(user.id);
    //           // remove auth user from recommended list
    //           if (isAuthUser) {
    //             return;
    //           } else if (isFollowingUser) {
    //             return;
    //           } else {
    //             RecommendedUser userResult = RecommendedUser(user);
    //             userRecommends.add(userResult);
    //           }
    //         });
    //
    //       },
    //     )
    //   ],
    // );
  }

  Future getTimeLinePosts() async {
    posts = await postServices.getPosts(isTimeLine: true);
    setState(() {
      postLoaded = true;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(Data.defaultUser.id)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeLinePosts()
        .then((value) => print('posts length is ${posts.length}'));
    getFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () => getTimeLinePosts(),
        child: _buildTimelinePosts(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AppLogo(),
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
}
