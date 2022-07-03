import 'dart:io';

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
        child: photoUrl == null || photoUrl!.isEmpty
            ? Icon(
                Icons.person_outline,
                size: radius,
                color: Colors.white,
              )
            : CircleAvatar(
                radius: radius,
                backgroundImage: _buildNetworkImage()));
  }


  ImageProvider _buildNetworkImage() {
    return NetworkImage(photoUrl!);
  }
}
