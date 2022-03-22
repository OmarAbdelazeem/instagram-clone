import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';

import '../widgets/or_divider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          AppLogo(),
          SizedBox(height: 30),
          _buildUserNameField(),
          SizedBox(height: 10),
          _buildPasswordField(),
          SizedBox(height: 10),
          _buildLoginButton(),
          SizedBox(height: 10),
          _buildForgotYourLoginDetails(),
          SizedBox(height: 10),
          OrDivider(),
          SizedBox(height: 20),
          _buildLoginWithFacebook(),
        ],
      ),
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: AppStrings.phoneNumberOrEmailOrUserName,
        filled: true,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: AppStrings.password,
        filled: true,
      ),
    );
  }

  Widget _buildLoginButton() {
    return AppButton(
      title: AppStrings.login,
      titleStyle: TextStyle(
        color: emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty
            ? Colors.white
            : Colors.white70,
      ),
      width: double.infinity,
      onTap:
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty
              ? onLoginTapped
              : null,
    );
  }

  Widget _buildForgotYourLoginDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          AppStrings.forgotYourLoginDetails,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          AppStrings.getHelpSigningIn,
          style:
              TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildLoginWithFacebook() {
    return AppButton(
      title: AppStrings.logInWithFacebook,
      titleStyle: TextStyle(
          color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 15),
      disabledColor: AppColors.scaffoldBackgroundColor,
      prefixIcon: SvgPicture.asset(
        AppImages.faceBookLogoSvg,
        width: 15,
        height: 15,
      ),
    );
  }

  void onLoginTapped() {
    // _auth
    //     .signInWithEmail(emailController.text, passwordController.text)
    //     .then((value) {
    //   if (value != null) {
    //     Navigator.pushAndRemoveUntil(context,
    //         MaterialPageRoute(builder: (context) => Home()), (route) => false);
    //   }
    // });
  }
}
