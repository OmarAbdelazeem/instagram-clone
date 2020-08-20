import 'package:flutter/material.dart';
import 'package:instagramapp/services/navigation_functions.dart';

import 'home.dart';

class PeopleSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading:false,
        title: Text('People Suggestions'),
        actions: <Widget>[
          Container(
              child:
                  IconButton(icon: Icon(Icons.arrow_forward,), onPressed: () {
                   NavigationFunctions.navigateToPageAndRemoveRoot(context, Home());
                  }))
        ],
      ),
    );
  }
}
