import 'package:flutter/material.dart';

import '../../../../res/app_strings.dart';
import '../../../common/app_text.dart';

class NoCommentsYetView extends StatelessWidget {
  const NoCommentsYetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(text: AppStrings.noCommentsYet,),
        SizedBox(height: 20,),
        AppText(text: AppStrings.startTheConversation,),
      ],
    );
  }
}
