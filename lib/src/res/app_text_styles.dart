import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle appBarTitleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static TextStyle hintStyle = TextStyle(fontSize: 17, color: AppColors.grey);

  static TextStyle defaultTextStyleNormal = TextStyle(
      fontSize: 17, color: AppColors.black, fontWeight: FontWeight.normal);

  static TextStyle defaultTextStyleBold = TextStyle(
      fontSize: 17, color: AppColors.black, fontWeight: FontWeight.bold);
}
