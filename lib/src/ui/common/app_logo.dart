import 'package:flutter/material.dart';

import '../../res/app_strings.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.instagram,
      style:
      TextStyle(color: Colors.black, fontFamily: 'Signatra', fontSize: 60),
    );
  }
}
