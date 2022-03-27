import 'package:flutter/material.dart';

import '../../../../../router.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';
import '../../../common/app_text_field.dart';

class PhoneView extends StatefulWidget {
  PhoneView({Key? key}) : super(key: key);

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
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
            icon: Text('EG +20 '),
            // validator: ValidatorUtils.validateEmail,
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
            onTap: () {
              if (_formKey.currentState!.validate())
                NavigationUtils.pushNamed(
                    route: AppRoutes.nameAndPasswordScreen,
                    context: context,
                    arguments: phoneController.text);
            },
          )
        ],
      ),
    );
  }

  void clearController() {
    phoneController.clear();
  }
}
