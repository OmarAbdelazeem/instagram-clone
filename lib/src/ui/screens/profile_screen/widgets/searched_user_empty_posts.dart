import 'package:flutter/material.dart';

import '../../../../res/app_strings.dart';
import '../../../../res/app_text_styles.dart';

class SearchedUserEmptyPostsView extends StatelessWidget {
  const SearchedUserEmptyPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.camera_alt_rounded, size: 60),
        SizedBox(
          height: 15,
        ),
        Text(
          AppStrings.noPostsYet,
          style: AppTextStyles.defaultTextStyleBold.copyWith(fontSize: 24),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
