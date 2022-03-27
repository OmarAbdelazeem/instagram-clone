import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/activity_screen/activity_screen.dart';
import 'package:instagramapp/src/ui/screens/comments_screen/comments_screen.dart';
import 'package:instagramapp/src/ui/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:instagramapp/src/ui/screens/people_suggestions_screen/people_suggestions_screen.dart';
import 'package:instagramapp/src/ui/screens/post_details_screen/post_details_screen.dart';
import 'package:instagramapp/src/ui/screens/searched_user_profile/searched_user_profile.dart';
import 'src/ui/screens/add_profile_photo_screen/add_profile_photo_screen.dart';
import 'src/ui/screens/profile_photo_added_screen/profile_photo_added_screen.dart';
import 'package:instagramapp/src/ui/screens/main_home_screen/main_home_screen.dart';
import 'package:instagramapp/src/ui/screens/name_and_password_screen/name_and_password_screen.dart';
import 'package:instagramapp/src/ui/screens/splash_screen/splash_screen.dart';
import 'package:instagramapp/src/ui/screens/unknown_route_screen.dart';
import 'src/ui/screens/auth_screen/auth_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splashScreen = "/";
  static const String mainHomeScreen = "/mainHomeScreen";
  static const String authScreen = "/authScreen";
  static const String nameAndPasswordScreen = "/nameAndPasswordScreen";
  static const String profilePhotoAddedScreen = "/profilePhotoAddedScreen";
  static const String addProfilePhotoScreen = "/addProfilePhotoScreen";
  static const String peopleSuggestionsScreen = "/peopleSuggestionsScreen";
  static const String activityScreen = "/activityScreen";
  static const String editProfileScreen = "/editProfileScreen";
  static const String commentsScreen = "/commentsScreen";
  static const String postDetailsScreen = "/postDetailsScreen";
  static const String profileScreen = "/profileScreen";
}

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return _customMaterialPageRoute(SplashScreen(), settings);
      case AppRoutes.mainHomeScreen:
        return _customMaterialPageRoute(MainHomeScreen(), settings);
      case AppRoutes.authScreen:
        return _customMaterialPageRoute(AuthScreen(), settings);
      case AppRoutes.nameAndPasswordScreen:
        return _customMaterialPageRoute(NameAndPasswordScreen(), settings);
      case AppRoutes.profilePhotoAddedScreen:
        return _customMaterialPageRoute(ProfilePhotoAddedScreen(), settings);
        case AppRoutes.addProfilePhotoScreen:
        return _customMaterialPageRoute(AddProfilePhotoScreen(), settings);
        case AppRoutes.peopleSuggestionsScreen:
        return _customMaterialPageRoute(PeopleSuggestionsScreen(), settings);
        case AppRoutes.activityScreen:
        return _customMaterialPageRoute(ActivityScreen(), settings);
        case AppRoutes.editProfileScreen:
        return _customMaterialPageRoute(EditProfileScreen(), settings);
        case AppRoutes.commentsScreen:
        return _customMaterialPageRoute(CommentsScreen(), settings);
        case AppRoutes.postDetailsScreen:
        return _customMaterialPageRoute(PostDetailsScreen(), settings);
      default:
        return _customMaterialPageRoute(UnKnownRouteScreen(), settings);
    }
  }

  MaterialPageRoute _customMaterialPageRoute(Widget widget,
          [RouteSettings? settings]) =>
      MaterialPageRoute(builder: (context) => widget, settings: settings);
}
