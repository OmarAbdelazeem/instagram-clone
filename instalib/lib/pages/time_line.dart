import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/sign_up/main_auth_page.dart';
import 'package:instagramapp/services/posts_service.dart';
import 'package:instagramapp/widgets/post_widget.dart';
import 'package:instagramapp/widgets/recommended_user.dart';

class TimeLine extends StatefulWidget {
//  final GlobalKey<ScaffoldState> navigatorKey;
//
//  TimeLine({this.navigatorKey});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine>
    with AutomaticKeepAliveClientMixin<TimeLine> {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
//      key: widget.navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xfffafafa),
            automaticallyImplyLeading: false,
            title: Text(
              'Instagram',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Signatra', fontSize: 30),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                },
                icon: SvgPicture.asset(
                  'assets/images/send.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          body: TimeLinePhotos(),
        ),
      ),
    );
  }
}

class TimeLinePhotos extends StatefulWidget {
  @override
  _TimeLinePhotosState createState() => _TimeLinePhotosState();
}

class _TimeLinePhotosState extends State<TimeLinePhotos> {
//  AuthService _auth = AuthService();
  List<PostWidget> posts = [];
  PostServices postServices = PostServices();
  bool postLoaded = false;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final followingRef = FirebaseFirestore.instance.collection('following');

  List<String> followingList = [];

  buildTimeline() {
    if (posts == null) {
      return CircularProgressIndicator();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => posts[index],
        itemCount: posts.length,
      );
    }
  }

  buildUsersToFollow() {
    return ListView(
      children: <Widget>[
        StreamBuilder(
          stream: usersRef
              .orderBy('timestamp', descending: true)
              .limit(30)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            List<RecommendedUser> userRecommends = [];
            snapshot.data.documents.forEach((doc) {
              UserModel user = UserModel.fromDocument(doc);
              final bool isAuthUser = Data.defaultUser.id == user.id;
              final bool isFollowingUser = followingList.contains(user.id);
              // remove auth user from recommended list
              if (isAuthUser) {
                return;
              } else if (isFollowingUser) {
                return;
              } else {
                RecommendedUser userResult = RecommendedUser(user);
                userRecommends.add(userResult);
              }
            });
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome To Instagram',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Follow people to start seeing the photos and videos they share.',
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
          },
        )
      ],
    );
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

//  buildTimeline() {
//    if (!postLoaded) {
//      return Center(child: CircularProgressIndicator());
//    } else if (posts.isEmpty) {
//      return Center(
//          child: Container(
//        child: Text('No Posts'),
//        height: 150,
//        width: double.infinity,
//      ));
//    } else {
//      return ListView.builder(
//        itemBuilder: (context, index) => posts[index],
//        itemCount: posts.length,
//      );
//    }
//  }

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
    return RefreshIndicator(
      onRefresh: () => getTimeLinePosts(),
      child: buildTimeline(),
    );
  }
}
