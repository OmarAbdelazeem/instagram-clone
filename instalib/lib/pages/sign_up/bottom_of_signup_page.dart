import 'package:flutter/material.dart';
import 'package:instagramapp/pages/log_in/loggin.dart';
import 'package:instagramapp/services/navigation_functions.dart';

class BottomOfSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Divider(
              color: Colors.black,
            ),
            width: double.infinity,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                      NavigationFunctions.navigateToPage(context, Loggin());
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
//              )
            ],
          ),
        ],
      ),
    );
  }
}
