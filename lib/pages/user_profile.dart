import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/pages/profile_components/user_own_photos.dart';
import 'package:instagramapp/pages/profile_components/user_mentioned_photos.dart';
import 'package:instagramapp/pages/profile_components/profile_details.dart';
import 'package:instagramapp/services/profile_service.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isOwnPosts = true;
  bool isTags = false;
  bool loaded = false;
  bool isFollowing = false;
  ProfileService profileService = ProfileService();
  int postsCount=0;
  int followersCount=0;
  int followingCount=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    ProfileService.isMyProfile = false;
    profileService.checkIfFollowing(forNeededUser: false).then((value) {
      isFollowing = value;
    });
    profileService
        .getProfileMainInfo(id: Data.currentUser.id)
        .then((user)async{
      var userFollowing = await profileService.getFollowingUsers(isMyProfile: true);
      var userFollowers = await profileService.getFollowersUsers(isMyProfile: true);
      var userPosts = await profileService.getFuturePosts(Data.currentUser.id);

      followingCount = userFollowing.documents.length;
      followersCount = userFollowers.documents.length;
      postsCount = userPosts.documents.length;

      Data.changeCurrentUser(user);
      setState(() {
        loaded = true;
      });
    });

//    Data.updateNeedUser().then((value) {
//      setState(() {
//        loaded = true;
//      });
//    });
//    profileService.deleteUsersFromFollowingList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    ProfileService.isMyProfile = true;
  }

  void followButton() {
    setState(() {
      isFollowing = true;
    });
    profileService.followingOperation();
  }

  void unFollowButton() {
    setState(() {
      isFollowing = false;
    });
    profileService.unFollowOperation();
  }

  @override
  Widget build(BuildContext context) {
//     profileService = Provider.of<ProfileService>(context, listen: true);

    print('profileService.neededUser is ${Data.currentUser}');

    return loaded
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xfffafafa),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text(Data.currentUser.userName,style: TextStyle(color: Colors.black),),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white10,
                  child: Column(
                    children: <Widget>[
                      profileMainDetails(
                        context: context,
                        postsCount: postsCount,
                        followingCount: followingCount,
                        followersCount: followersCount,
                        isMyProfile: false,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: RaisedButton(
                                color:
                                    !isFollowing ? Colors.blue : Colors.white,
                                onPressed:
                                    isFollowing ? unFollowButton : followButton,
                                child: !isFollowing
                                    ? Text('Follow',style: TextStyle(color: Colors.white),)
                                    : Text('Following'),
                              ),
                            ),
//                      SizedBox(
//                        width: 15,
//                      ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: RaisedButton(
                                color: Colors.white,
                                onPressed: () {},
                                child: Text('Message'),
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 35,
                              child: Icon(Icons.arrow_drop_down),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      wayOfView(context)
                    ],
                  ),
                ),
                isOwnPosts
                    ? userOwnPhotos(Data.currentUser.id)
                    : noMentionedPhotos()
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
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
