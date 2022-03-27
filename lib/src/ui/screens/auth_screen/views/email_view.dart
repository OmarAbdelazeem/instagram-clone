import 'package:flutter/material.dart';

import '../../../../../router.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/utils/validator_utils.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';

class EmailView extends StatefulWidget {
  EmailView({Key? key}) : super(key: key);

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
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
            onTap: () {
              if (_formKey.currentState!.validate())
                NavigationUtils.pushNamed(
                    route: AppRoutes.nameAndPasswordScreen,
                    context: context,
                    arguments: emailController.text);
            },
          )
        ],
      ),
    );
  }

  void clearController() {
    emailController.clear();
  }
}
