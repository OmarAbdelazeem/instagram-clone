import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_logo.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_strings.dart';


class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
        ),
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              AppLogo(),
              _buildLoginWithFacebook(context),
              Column(
                children: <Widget>[
                  _buildOrDivider(context),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton(
                    child: Text(
                      AppStrings.signUpWithEmailOrPhoneNumber,
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // NavigationFunctions.navigateToPage(context, SignUpPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildOrDivider(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Divider(
              color: AppColors.grey,
            )),
        SizedBox(width: 5,),
        Expanded(
            child: Divider(
              color: AppColors.grey,
            )),
      ],
    );
  }

  Widget _buildLoginWithFacebook(BuildContext context) {
    return AppButton(title: AppStrings.logInWithFacebook,
        prefixIcon: SvgPicture.asset(
          AppImages.faceBookLogoSvg,
          width: 15,
          height: 15,
          color: Colors.white,
        ), width: double.infinity,);
    // return Padding(
    //   padding: const EdgeInsets.only(top: 50),
    //   child: Container(
    //     width: MediaQuery.of(context).size.width * 0.9,
    //     height: 45,
    //     child: RaisedButton(
    //       color: Colors.blue,
    //       onPressed: () {},
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           SvgPicture.asset(
    //             AppImages.faceBookLogoSvg,
    //             width: 15,
    //             height: 15,
    //             color: Colors.white,
    //           ),
    //           SizedBox(
    //             width: 5,
    //           ),
    //           Text(
    //             AppStrings.logInWithFacebook,
    //             style: TextStyle(color: Colors.white),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

}
