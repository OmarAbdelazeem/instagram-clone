import 'package:flutter/material.dart';
import 'package:instagramapp/data/data.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/pages/user_profile.dart';
import 'package:instagramapp/services/profile_service.dart';


class SearchResultWidget extends StatelessWidget {
  final User user;

  SearchResultWidget({this.user});

  buildUserPhoto() {
    return user.photoUrl == ''
        ? CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person_outline,
              size: 40,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffFDCF09),
            child: CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(user.photoUrl)),
          );
  }

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = ProfileService();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfile(),
          ),
        );
        Data.changeCurrentUser(user);
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildUserPhoto(),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.userName,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
