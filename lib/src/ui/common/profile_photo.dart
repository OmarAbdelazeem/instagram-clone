import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String? photoUrl;
  ProfilePhoto(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return photoUrl != null
        ? Container(
      height: 85,
      width: 85,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Color(0xffFDCF09),
        child: CircleAvatar(
            radius: 50, backgroundImage: NetworkImage(photoUrl!)),
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
}
