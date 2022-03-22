import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_strings.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Divider(
          color: AppColors.grey,
        )),
        SizedBox(
          width: 10,
        ),
        Text(
          AppStrings.or,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.grey),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Divider(
          color: AppColors.grey,
        )),
      ],
    );
  }
}
