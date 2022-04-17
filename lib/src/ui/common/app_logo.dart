import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import '../../res/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;

  const AppLogo({Key? key, this.fontSize = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.instagram,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: AppColors.black, fontFamily: 'Signatra', fontSize: fontSize),
    );
  }
}
