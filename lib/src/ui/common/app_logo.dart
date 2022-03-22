import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import '../../res/app_strings.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.instagram,
      style: TextStyle(
          color: AppColors.black, fontFamily: 'Signatra', fontSize: 60),
    );
  }
}
