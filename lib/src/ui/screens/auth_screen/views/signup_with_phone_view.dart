import 'package:flutter/material.dart';

import '../../../../../router.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/utils/validator_utils.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';

class SignupWithPhoneView extends StatefulWidget {
  final FocusNode focusNode;

  SignupWithPhoneView({Key? key, required this.focusNode}) : super(key: key);

  @override
  State<SignupWithPhoneView> createState() => _SignupWithPhoneViewState();
}

class _SignupWithPhoneViewState extends State<SignupWithPhoneView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: phoneController,
            focusNode: widget.focusNode,
            icon: Text('EG +20 '),
            validator: ValidatorUtils.validateEmail,
            hintText: AppStrings.phone,
            keyBoardType: TextInputType.phone,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearController,
            ),
          ),
          AppButton(
            width: double.infinity,
            title: AppStrings.next,
            onTap: onNextTapped,
          )
        ],
      ),
    );
  }

  void clearController() {
    phoneController.clear();
  }

  void onNextTapped() {
    if (_formKey.currentState!.validate())
      NavigationUtils.pushNamed(
          route: AppRoutes.nameAndPasswordScreen,
          context: context,
          arguments: phoneController.text);
  }
}
