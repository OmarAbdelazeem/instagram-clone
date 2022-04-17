import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get lightTheme {
    //1
    return ThemeData(
      //2
      primaryColor: AppColors.blue,
      appBarTheme: AppBarTheme(
          color: AppColors.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          titleTextStyle: TextStyle(color: AppColors.black)),
      iconTheme: IconThemeData(color: AppColors.black),
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      // fontFamily: 'Montserrat', //3
      // buttonTheme: ButtonThemeData( // 4
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      //   buttonColor: CustomColors.lightPurple,
      // )
    );
  }
}
