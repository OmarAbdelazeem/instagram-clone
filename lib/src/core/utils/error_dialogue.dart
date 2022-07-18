import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';

void showErrorDialogue(BuildContext context, String error) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            title: Text(
              AppStrings.error,
              style: AppTextStyles.defaultTextStyleBold,
            ),
            children: <Widget>[
              Center(
                  child: Text(
                error,
                style: AppTextStyles.defaultTextStyleNormal.copyWith(fontSize: 16),
              ))
            ]);
      });
}
