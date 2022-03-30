import 'package:flutter/material.dart';

import '../../../../../router.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/utils/validator_utils.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';

class SignupWithEmailView extends StatefulWidget {
  final FocusNode focusNode;

  SignupWithEmailView({Key? key, required this.focusNode}) : super(key: key);

  @override
  State<SignupWithEmailView> createState() => _SignupWithEmailViewState();
}

class _SignupWithEmailViewState extends State<SignupWithEmailView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: emailController,
            focusNode: widget.focusNode,
            validator: ValidatorUtils.validateEmail,
            hintText: AppStrings.email,
            keyBoardType: TextInputType.emailAddress,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearController,
            ),
          ),
          AppButton(
            width: double.infinity,
            title: AppStrings.next,
            onTap: onNextButtonTapped,
          )
        ],
      ),
    );
  }

  void clearController() {
    emailController.clear();
  }

  void onNextButtonTapped() {
    // Todo first check if this is already found in the database
    if (_formKey.currentState!.validate())
      NavigationUtils.pushNamed(
          route: AppRoutes.nameAndPasswordScreen,
          context: context,
          arguments: emailController.text);
  }
}
