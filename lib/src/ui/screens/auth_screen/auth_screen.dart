import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/screens/auth_screen/views/login_view.dart';
import 'package:instagramapp/src/ui/screens/auth_screen/views/signup_view.dart';

enum AuthState { login, signup }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthState authState = AuthState.signup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          authState == AuthState.login ? LoginView() : SignupView(),
          _buildBottomLoginAndSignupButtons()
        ],
      ),
    );
  }

  Widget _buildBottomLoginAndSignupButtons() {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
              child: Divider(
            color: AppColors.grey,
          )),
          SizedBox(
            height: 5,
          ),
          authState == AuthState.login
              ? _buildSignupStatementView()
              : _buildLoginStatementView()
        ],
      ),
    );
  }

  Widget _buildLoginStatementView() {
    return _buildStatementWithActionButton(
        buttonTitle: AppStrings.login,
        statement: AppStrings.alreadyHaveAnAccount,
        onTap: () {
          setState(() {
            authState = AuthState.login;
          });
        });
  }

  Widget _buildSignupStatementView() {
    return _buildStatementWithActionButton(
        buttonTitle: AppStrings.signup,
        statement: AppStrings.dontHaveAnAccount,
        onTap: () {
          setState(() {
            authState = AuthState.signup;
          });
        });
  }

  Widget _buildStatementWithActionButton(
      {required String statement,
      required String buttonTitle,
      required void Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(statement),
        GestureDetector(
          onTap: onTap,
          child: Text(
            buttonTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
