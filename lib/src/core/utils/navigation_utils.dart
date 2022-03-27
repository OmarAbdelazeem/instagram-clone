import 'package:flutter/material.dart';

class NavigationUtils {
  NavigationUtils._();

  static void pushNamed(
      {required String route,
      required BuildContext context,
      dynamic arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }


  static void pushScreen(
      {required Widget screen,
        required BuildContext context,}) {
    Navigator.push(context, MaterialPageRoute(builder: (_)=> screen));
  }
}
