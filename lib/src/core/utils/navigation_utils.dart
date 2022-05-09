import 'package:flutter/material.dart';

class NavigationUtils {
  NavigationUtils._();

  static Future pushNamed(
      {required String route,
      required BuildContext context,
      dynamic arguments}) {
    return Navigator.pushNamed(context, route, arguments: arguments);
  }

  static void pushNamedAndPopUntil(String route, BuildContext context,
      [dynamic arguments]) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false,
        arguments: arguments);
  }

  static Future pushScreen({
    required Widget screen,
    required BuildContext context,
  }) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
