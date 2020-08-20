import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';
import 'package:instagramapp/pages/profile_components/user_mentioned_photos.dart';
import 'package:instagramapp/pages/profile_components/user_own_photos.dart';
import 'package:instagramapp/services/auth.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/profile_service.dart';

import 'edit_profile.dart';

class MyProfile extends StatefulWidget {
//  final GlobalKey<ScaffoldState> navigatorKey;
//
//  MyProfile({this.navigatorKey});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with AutomaticKeepAliveClientMixin<MyProfile>{
  bool isOwnPosts = true;
  bool isTags = false;
  bool loaded = false;
  int postsCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  ProfileService profileService = ProfileService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    ProfileService.isMyProfile = true;
    print('init state called');
//    AuthService authService = AuthService();
    setProfileInfo().then((value) => setState(() {
          loaded = true;
        }));
  }

  Future setProfileInfo() {
    return Data.updateDefaultUser().then((value) async {
      var userFollowing =
          await profileService.getFollowingUsers(isMyProfile: true);
      var userFollowers =
          await profileService.getFollowersUsers(isMyProfile: true);
      var userPosts = await profileService.getFuturePosts(Data.defaultUser.id);

    setState(() {
      followingCount = userFollowing.documents.length;
      followersCount = userFollowers.documents.length;
      postsCount = userPosts.documents.length;
    });
    });
  }

  editProfile() {
    NavigationFunctions.pushPage(isHorizontalNavigation: false,context: context,page: EditProfile());
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => EditProfile()));
  }
  bool get wantKeepAlive =>true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('loaded is $loaded');
    return Navigator(
//      key: widget.navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => loaded
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xfffafafa),
                  title: Text(Data.defaultUser.userName,style: TextStyle(color: Colors.black),),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu,color: Colors.black,),
                      onPressed: () {},
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () async{
                    setProfileInfo();
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        color: Colors.white10,
                        child: Column(
                          children: <Widget>[
                            profileMainDetails(
                              context: context,
                              followersCount: followersCount,
                              followingCount: followingCount,
                              postsCount: postsCount,
                              isMyProfile: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: RaisedButton(
                                  color: Colors.white,
                                  onPressed: editProfile,
                                  child: Text('Edit Profile'),
                                ),
                              ),
                            ),
                            wayOfView(context)
                          ],
                        ),
                      ),
                      isOwnPosts
                          ? userOwnPhotos(Data.defaultUser.id)
                          : noMentionedPhotos()
                    ],
                  ),
                ))
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget wayOfView(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    isOwnPosts = true;
                    isTags = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.grid_on,
                        color: isOwnPosts ? Colors.black87 : Colors.grey,
                      ),
                      Divider(
                        thickness: 1.5,
                        color: isOwnPosts ? Colors.black87 : Colors.white12,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTags = true;
                    isOwnPosts = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        color: isTags ? Colors.black87 : Colors.grey,
                      ),
                      Divider(
                        thickness: 1.5,
                        color: isTags ? Colors.black87 : Colors.white12,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
