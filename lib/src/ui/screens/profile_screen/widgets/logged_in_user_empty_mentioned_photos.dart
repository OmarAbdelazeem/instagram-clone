import 'package:flutter/material.dart';

import '../../../../res/app_strings.dart';
class LoggedInUserEmptyMentionedPhotos extends StatelessWidget {
  const LoggedInUserEmptyMentionedPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          AppStrings.photosAndVideosOfYou,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          AppStrings.whenPeopleTagYouIn,
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
