import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  ProfilePhoto({
    this.photoUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: photoUrl != null
            ? CircleAvatar(
                radius: radius, backgroundImage: NetworkImage(photoUrl!))
            : Icon(
                Icons.person_outline,
                size: radius,
                color: Colors.white,
              ));
  }
}
