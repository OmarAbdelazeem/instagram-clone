import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/people_suggestions_screen/people_suggestions_screen.dart';

import '../../../../router.dart';
import '../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../../../core/utils/loading_dialogue.dart';

//Todo refactor this screen
class ProfilePhotoAddedScreen extends StatefulWidget {
  @override
  _ProfilePhotoAddedScreenState createState() =>
      _ProfilePhotoAddedScreenState();
}

class _ProfilePhotoAddedScreenState extends State<ProfilePhotoAddedScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  void onNextTapped() {
    context.read<LoggedInUserBloc>().add(FetchLoggedInUserDetailsStarted());
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                ProfilePhoto(photoUrl: imageUrl, radius: 50),
                SizedBox(
                  height: 15,
                ),
                Text(
                  AppStrings.profilePhotoAdded,
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  AppStrings.changePhoto,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppStrings.alsoShareThisPhotoAsAPost,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                    Switch(
                      onChanged: (val) {},
                      value: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppStrings.makeThisPhotoYourFirstPostSo,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 15,
                ),
                BlocListener<LoggedInUserBloc, LoggedInUserState>(
                  listener: (context, state) {
                    if (state is LoggedInUserDetailsLoaded) {
                      Navigator.of(_keyLoader.currentContext!,
                              rootNavigator: true)
                          .pop();
                      NavigationUtils.pushNamedAndPopUntil(
                          AppRoutes.mainHomeScreen, context);
                    } else if (state is LoggedInUserDetailsLoading) {
                      showLoadingDialog(context, _keyLoader);
                    }
                  },
                  child: AppButton(
                    title: AppStrings.next,
                    onTap: onNextTapped,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
