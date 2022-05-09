import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_images.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import 'package:instagramapp/src/ui/common/loading_dialogue.dart';
import '../widgets/or_divider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  bool loginEnabled = false;

  @override
  void initState() {
    super.initState();
    //Todo fix this as before
    // emailController.addListener(() {
    //   setState(() {
    //     loginEnabled = emailController.text.isNotEmpty &&
    //         passwordController.text.isNotEmpty;
    //   });
    // });
    //
    // passwordController.addListener(() {
    //   setState(() {
    //     loginEnabled = passwordController.text.isNotEmpty &&
    //         emailController.text.isNotEmpty;
    //   });
    // });
  }

  void _usersBlocListener(BuildContext context, AuthState state) {
    if (state is Loading)
      showLoadingDialog(context, _keyLoader);
    else if (state is AuthSuccess) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      NavigationUtils.pushNamedAndPopUntil(AppRoutes.mainHomeScreen, context);
      context.read<LoggedInUserBloc>().add(SetLoggedInUserStarted(state.user));
    } else if (state is Error)
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
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
    return AppTextField(
      controller: emailController,
      hintText: AppStrings.phoneNumberOrEmailOrUserName,
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      controller: passwordController,
      hintText: AppStrings.password,
      obscureText: true,
    );
  }

  Widget _buildLoginButton() {
    return BlocListener<AuthBloc, AuthState>(
      listener: _usersBlocListener,
      child: AppButton(
        title: AppStrings.login,
        titleStyle: TextStyle(
          color: loginEnabled ? Colors.white : Colors.white70,
        ),
        width: double.infinity,
        onTap: emailController.text.isNotEmpty &&
                passwordController.text.isNotEmpty
            ? _onLoginTapped
            : null,
      ),
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

  void _onLoginTapped() {
    context.read<AuthBloc>().add(LoginStarted(
        email: emailController.text, password: passwordController.text));
  }
}
