import 'package:flutter/material.dart';

import 'package:instagramapp/pages/sign_up/main_auth_page.dart';

class BottomOfLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 50,
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
                Text('Don\'t have an account? '),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainAuthPage()));
                  },
                  child: Text(
                    'Sign up',
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
      ),
    );
  }
}
