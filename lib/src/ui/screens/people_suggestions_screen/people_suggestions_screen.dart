import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../router.dart';
import '../../../core/utils/loading_dialogue.dart';

class PeopleSuggestionsScreen extends StatelessWidget {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  void _onSkipTapped(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppStrings.peopleSuggestions),
        actions: <Widget>[
          BlocListener<LoggedInUserBloc, LoggedInUserState>(
            listener: (context, state) {
              if (state is LoggedInUserDetailsLoaded) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                NavigationUtils.pushNamedAndPopUntil(
                    AppRoutes.mainHomeScreen, context);

              } else if (state is LoggedInUserDetailsLoading) {
                showLoadingDialog(context, _keyLoader);
              }
            },
            // child: IconButton(
            //     icon: Icon(
            //       Icons.arrow_forward,
            //     ),
            //     onPressed: () => _onSkipTapped(context)),
          )
        ],
      ),
    );
  }
}
