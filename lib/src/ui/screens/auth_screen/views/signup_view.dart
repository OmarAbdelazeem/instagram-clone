import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_tabs.dart';
import '../../name_and_password_screen/name_and_password_screen.dart';
import '../sign_up/email_or_phone_option.dart';
import '../widgets/or_divider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  int currentTabIndex = 0;
  bool isSignUpWithEmailOrPhone = false;
  bool isEmailActive = true;
  bool isPhoneActive = false;
  TextEditingController emailAndPhoneController = TextEditingController();
  String inputVal = '';

  void clearEmailAndPhoneController() {
    emailAndPhoneController.clear();
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.person_pin,
                      size: 160,
                    ),
                    AppTabs(
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
                          });
                        },
                        selectedIndex: currentTabIndex),
                    // Container(
                    //     width: MediaQuery.of(context).size.width * 0.9,
                    //     child: Row(
                    //       children: <Widget>[
                    //         GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               isPhoneActive = true;
                    //               isEmailActive = false;
                    //             });
                    //           },
                    //           child: EmailOrPhoneOption(
                    //             isActive: isPhoneActive,
                    //             optionType: 'Phone',
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               isEmailActive = true;
                    //               isPhoneActive = false;
                    //             });
                    //           },
                    //           child: EmailOrPhoneOption(
                    //             isActive: isEmailActive,
                    //             optionType: 'Email',
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                    customTextField(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 40,
                      child: RaisedButton(
                        disabledColor: Color(0xffb6e2fa),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              color: inputVal != ''
                                  ? Colors.white
                                  : Colors.white70),
                        ),
                        onPressed: inputVal != ''
                            ? () {
                                // Todo fix this as before
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NameAndPasswordScreen(
                                              email:
                                                  emailAndPhoneController.text,
                                            )));
                                // NavigationFunctions.navigateToPage(
                                //   context,
                                //   NameAndPassword(
                                //     email: emailAndPhoneController.text,
                                //   ),
                                // );
                              }
                            : null,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // BottomOfSignUpPage()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customTextField() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 38,
        margin: EdgeInsets.all(2),
        child: TextFormField(
          onChanged: (val) {
            setState(() {
              inputVal = val;
              print(inputVal);
            });
          },
          keyboardType:
              isEmailActive ? TextInputType.emailAddress : TextInputType.number,
          controller: emailAndPhoneController,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfffafafa),
              hintText: isEmailActive ? "Email" : 'Phone',
              filled: true,
              suffixIcon: IconButton(
                color: Colors.grey,
                icon: Icon(Icons.clear),
                onPressed: clearEmailAndPhoneController,
              ),
              icon: !isEmailActive ? Text('EG +20 ') : null),
        ),
      ),
    );
  }
}
