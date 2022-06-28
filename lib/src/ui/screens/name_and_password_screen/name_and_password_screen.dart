import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';

import '../../../core/utils/loading_dialogue.dart';

class NameAndPasswordScreen extends StatefulWidget {
  @override
  _NameAndPasswordScreenState createState() => _NameAndPasswordScreenState();
}

class _NameAndPasswordScreenState extends State<NameAndPasswordScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String? email;

  void onContinueTapped() {
    //Todo implement create user with email and password
    context.read<AuthBloc>().add(SignUpWithEmailStarted(
        password: passwordController.text,
        email: email!,
        name: nameController.text));
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Loading)
                showLoadingDialog(context, _keyLoader);
              else if (state is AuthSuccess) {
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
                NavigationUtils.pushNamed(
                    route: AppRoutes.addProfilePhotoScreen, context: context);
                // context.read<ProfileBloc>().add(ProfileDataUpdated(state.user));
              } else if (state is Error)
                Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                    .pop();
            },
            child: AppButton(
              title: AppStrings.continuE,
              onTap: onContinueTapped,
            ),
          )
        ]),
      ),
    );
  }
}
