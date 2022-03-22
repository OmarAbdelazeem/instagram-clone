import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_strings.dart';
import '../widgets/or_divider.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          AppLogo(),
          SizedBox(
            height: 100,
          ),
          _buildLoginWithFacebook(context),
          SizedBox(
            height: 50,
          ),
          OrDivider(),
          SizedBox(
            height: 15,
          ),
          AppButton(
            title: AppStrings.signUpWithEmailOrPhoneNumber,
            color: AppColors.scaffoldBackgroundColor,
            titleStyle:
                TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
            disabledColor: AppColors.scaffoldBackgroundColor,
          )
        ],
      ),
    );
  }

  Widget _buildLoginWithFacebook(BuildContext context) {
    return AppButton(
      title: AppStrings.logInWithFacebook,
      prefixIcon: SvgPicture.asset(
        AppImages.faceBookLogoSvg,
        width: 15,
        height: 15,
        color: Colors.white,
      ),
      width: double.infinity,
    );
  }
}
