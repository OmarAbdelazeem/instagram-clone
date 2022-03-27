import 'package:flutter/material.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';

class NameAndPasswordScreen extends StatefulWidget {
  @override
  _NameAndPasswordScreenState createState() => _NameAndPasswordScreenState();
}

class _NameAndPasswordScreenState extends State<NameAndPasswordScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? email;

  void onContinueTapped(){
    //Todo implement create user with email and password
    NavigationUtils.pushNamed(
        route: AppRoutes.addProfilePhotoScreen, context: context);
  }

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)!.settings.arguments as String;
    print("args is $email");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: <Widget>[
          SizedBox(height: 120),
          Text(
            AppStrings.nameAndPassword,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          AppTextField(controller: nameController, hintText: AppStrings.name),
          AppTextField(
              controller: passwordController, hintText: AppStrings.password),
          SizedBox(
            height: 10,
          ),
          AppButton(
            title: AppStrings.continuE,
            onTap: onContinueTapped,
          )
        ]),
      ),
    );
  }
}
