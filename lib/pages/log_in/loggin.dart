import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/pages/home.dart';
import 'package:instagramapp/services/auth.dart';
import 'package:instagramapp/widgets/or_divider.dart';
import 'bottom_of_login_page.dart';

class Loggin extends StatefulWidget {
  @override
  _LogginState createState() => _LogginState();
}

class _LogginState extends State<Loggin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthService _auth = AuthService();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Instagram',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Signatra',
                              fontSize: 60),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            onChanged: (val) {
                              email = val;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone number, email, or username",
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15, left: 10, right: 10, top: 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
//                              fillColor: Color(0xfffafafa),
                              hintText: 'Password',
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 40,
                        child: RaisedButton(
                          disabledColor: Color(0xffb6e2fa),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: email != '' && password != ''
                                    ? Colors.white
                                    : Colors.white70),
                          ),
                          onPressed: email != '' && password != ''
                              ? () {
                                  if (emailController.text.isNotEmpty != null &&
                                      passwordController.text.isNotEmpty) {
                                    _auth
                                        .signInWithEmail(emailController.text,
                                            passwordController.text)
                                        .then((value) {
                                      if (value != null) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Home()),
                                            (route) => false);
                                      }
                                    });
                                  }
                                }
                              : null,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Forgot your login details? ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Get help signing in.',
                              style: TextStyle(
                                  color: Color(0xff184064),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      orWithDivider(context),
                      FlatButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/images/facebook-logo.svg',
                              width: 15,
                              height: 15,
//                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Log in with Facebook',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  BottomOfLoginPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
