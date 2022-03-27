import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';
import '../../../../../router.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_tabs.dart';
import '../widgets/or_divider.dart';

enum SignUpType { email, phone }

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  int currentTabIndex = 0;
  bool isSignUpWithEmailOrPhone = false;
  SignUpType currentSignUpType = SignUpType.email;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void clearController() {
    currentSignUpType == SignUpType.email
        ? emailController.clear()
        : phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isSignUpWithEmailOrPhone = false;
        });
        return false;
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return isSignUpWithEmailOrPhone
        ? _buildSignUpWithEmailOrPhoneView()
        : _buildMainSignUpView();
  }

  Widget _buildMainSignUpView() {
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
            onTap: () {
              setState(() {
                isSignUpWithEmailOrPhone = true;
              });
            },
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

  Widget _buildSignUpWithEmailOrPhoneView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
          Icon(
            Icons.person_pin,
            size: 160,
          ),
          _buildAppTabs(),
          SizedBox(
            height: 10,
          ),
          _buildCurrentSignUpTypeView()
        ],
      ),
    );
  }

  AppTabs _buildAppTabs() {
    return AppTabs(
        items: [
          AppTabItemModel(
              selectedItem: Text(
                AppStrings.phone,
                style: TextStyle(color: AppColors.black),
              ),
              unSelectedItem: Text(
                AppStrings.phone,
                style: TextStyle(color: AppColors.grey),
              )),
          AppTabItemModel(
              selectedItem: Text(
                AppStrings.email,
                style: TextStyle(color: AppColors.black),
              ),
              unSelectedItem: Text(
                AppStrings.email,
                style: TextStyle(color: AppColors.grey),
              )),
        ],
        onItemChanged: (int val) {
          setState(() {
            currentTabIndex = val;
            currentSignUpType =
                currentTabIndex == 0 ? SignUpType.email : SignUpType.phone;
          });
        },
        selectedIndex: currentTabIndex);
  }

  Widget _buildCurrentSignUpTypeView() {
    bool isEmail = currentSignUpType == SignUpType.email;
    return Column(
      children: [
        AppTextField(
          controller: isEmail ? emailController : phoneController,
          icon: isEmail ? null : Text('EG +20 '),
          hintText: isEmail ? AppStrings.email : AppStrings.phone,
          keyBoardType:
              isEmail ? TextInputType.emailAddress : TextInputType.phone,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearController,
          ),
        ),
        AppButton(
          width: double.infinity,
          title: AppStrings.next,
          onTap: () {
            NavigationUtils.pushNamed(
                route: AppRoutes.nameAndPasswordScreen,
                context: context,
                arguments: emailController.text);
          },
        )
      ],
    );
  }
}
