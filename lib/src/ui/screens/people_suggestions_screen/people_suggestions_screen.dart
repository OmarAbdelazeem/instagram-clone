import 'package:flutter/material.dart';


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
                  onPressed: () {

                    // NavigationFunctions.navigateToPageAndRemoveRoot(
                    //     context, Home());
                  }))
        ],
      ),
    );
  }
}
