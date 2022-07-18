import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';

import '../../../core/utils/loading_dialogue.dart';

class UpdateFieldScreen extends StatefulWidget {
  final String title;
  final String value;
  String? Function(String?)? validator;

  UpdateFieldScreen(
      {Key? key, required this.title, required this.value, this.validator})
      : super(key: key);

  @override
  State<UpdateFieldScreen> createState() => _UpdateFieldScreenState();
}

class _UpdateFieldScreenState extends State<UpdateFieldScreen> {
  late TextEditingController controller;
  late LoggedInUserBloc loggedInUserBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(key: _formKey, child: _buildTextField()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: Text(widget.title, style: AppTextStyles.appBarTitleStyle),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: closeScreen,
          icon: Icon(
            Icons.close_sharp,
            size: 30.0,
            // color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          BlocListener<LoggedInUserBloc, LoggedInUserState>(
            listener: _updateFieldListener,
            child: IconButton(
              onPressed: updateField,
              icon: Icon(
                Icons.done,
                size: 30.0,
                color: Colors.blue,
              ),
            ),
          ),
        ]);
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        controller: controller,
        validator: widget.validator,
        autoFocus: true,
        fillColor: AppColors.scaffoldBackgroundColor,
        border: UnderlineInputBorder(),
      ),
    );
  }

  void closeScreen() {
    Navigator.pop(context);
  }

  void updateField() {
    if(_formKey.currentState!.validate()){
      UserData? userData;
      switch (widget.title) {
        case AppStrings.bio:
          userData = UserData.bio;
          break;
        case AppStrings.name:
          userData = UserData.name;
          break;
      }
      loggedInUserBloc.add(UpdateUserDataEventStarted(
          userData: userData!, value: controller.text));
    }

  }

  void _updateFieldListener(BuildContext context, state) async {
    if (state is UpdatingUserData)
      showLoadingDialog(context, _keyLoader);
    else if (state is UpdatedUserData) {
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      Navigator.pop(context, controller.text);
    } else if (state is UpdateUserDataError) {
      //Todo show alert here
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }
}
