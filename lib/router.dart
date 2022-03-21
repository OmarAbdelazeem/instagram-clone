import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/main_home_screen/main_home_screen.dart';
import 'package:instagramapp/src/ui/screens/splash_screen/splash_screen.dart';
import 'package:instagramapp/src/ui/screens/unknown_route_screen.dart';
import 'src/ui/screens/auth_screen/auth_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String mainHomeScreen = "/mainHomeScreen";
  static const String authScreen = "/";
}

class AppRouter {

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return _customMaterialPageRoute(SplashScreen());
      case AppRoutes.mainHomeScreen:
        return _customMaterialPageRoute(MainHomeScreen());
      case AppRoutes.authScreen:
        return _customMaterialPageRoute(AuthScreen());
      default:
        return _customMaterialPageRoute(UnKnownRouteScreen());
    }
  }

  MaterialPageRoute _customMaterialPageRoute(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

}