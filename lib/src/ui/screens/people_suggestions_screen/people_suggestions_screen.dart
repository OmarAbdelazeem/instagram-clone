import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import '../../../../router.dart';

class PeopleSuggestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('People Suggestions'),
        actions: <Widget>[
          Container(
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                  ),
                  onPressed: () => NavigationUtils.pushNamed(
                      route: AppRoutes.mainHomeScreen, context: context)))
        ],
      ),
    );
  }
}
