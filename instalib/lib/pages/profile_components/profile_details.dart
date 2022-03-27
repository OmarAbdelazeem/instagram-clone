import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';


Widget profileMainDetails({
  BuildContext context,
  bool isMyProfile,
  int postsCount,
  int followingCount,
  int followersCount
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
//            ProfileService.isMyProfile
            isMyProfile? _myProfilePhoto(photoUrl: Data.defaultUser.photoUrl)
                : userProfilePhoto(
                    photoUrl: Data.currentUser.photoUrl),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        numericInfo(
                            postsCount, 'Posts'),
                        numericInfo(followersCount,
                            'Followers'),
                        numericInfo(
                            followingCount,
                            'Following'),
                      ],
                    ),
            ),
          ],
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 17.0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isMyProfile
                    ? Data.defaultUser.userName
                    : Data.currentUser.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              isMyProfile
                  ? Text(Data.defaultUser.bio)
                  : Text(Data.currentUser.bio),
            ],
          )),
    ],
  );
}

Widget numericInfo(int count, String name) {
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

Widget userProfilePhoto({String photoUrl}) {
  return photoUrl != null
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

Widget _myProfilePhoto({String photoUrl}) {
  return Container(
    height: 85,
    width: 85,
    child: Stack(
      children: <Widget>[
        Container(
          height: 80,
          width: 80,
          child: photoUrl != null
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
