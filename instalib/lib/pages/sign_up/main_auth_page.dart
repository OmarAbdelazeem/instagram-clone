import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/pages/sign_up/signup_page.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/widgets/or_divider.dart';
import 'bottom_of_signup_page.dart';

class MainAuthPage extends StatefulWidget {
  @override
  _MainAuthPageState createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Instagram',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Signatra', fontSize: 70),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 45,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                              'assets/images/facebook-logo.svg',
                            width: 15,
                            height: 15,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            'Log in with facebook',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    orWithDivider(context),
                    SizedBox(
                      height: 15,
                    ),
                    FlatButton(
                      child: Text(
                        'Sign up with email or phone number',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: (){
                        NavigationFunctions.navigateToPage(context, SignUpPage());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          BottomOfSignUpPage()
        ],
      ),
    );
  }
}
