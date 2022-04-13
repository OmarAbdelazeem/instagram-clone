import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/bloc/posts_bloc/posts_bloc.dart';
import 'package:instagramapp/src/bloc/profile_bloc/profile_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';

import '../../../../router.dart';
import '../../../bloc/users_bloc/users_bloc.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../common/loading_dialogue.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  bool loading = false;
  XFile? imageFile;

  _onShareTapped() async {
    context.read<PostsBloc>().add(PostUploadStarted(imageFile!,
        captionController.text, context.read<UsersBloc>().loggedInUserDetails!));
  }


  @override
  Widget build(BuildContext context) {
    imageFile = ModalRoute.of(context)!.settings.arguments as XFile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildWriteACaptionTextFormField(context),
          ),
          Divider(
            color: AppColors.grey,
          ),
          _buildTagPeopleButton(),
          Divider(
            color: AppColors.grey,
          ),
          _buildAddLocationButton(),
          Divider(
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildAddLocationButton() {
    return TextButton(
      // onPressed: getUserLocation,
      onPressed: () {},
      child: Text(AppStrings.addLocation),
    );
  }

  Widget _buildTagPeopleButton() {
    return TextButton(
      onPressed: () {},
      child: Text(AppStrings.tagPeople, style: TextStyle(color: AppColors.black)),
    );
  }

  Widget _buildWriteACaptionTextFormField(BuildContext context) {
    return AppTextField(
      controller: captionController,
      maxLines: 3,
      hintText: AppStrings.writeACaption,
      icon: Image.file(
        File(imageFile!.path),
        width: 55,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.newPost,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        BlocListener<PostsBloc, PostsState>(
          listener: (context, state) {
            if (state is UpLoadingPost) showLoadingDialog(context, _keyLoader);
            if (state is PostUploaded) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              NavigationUtils.pushNamedAndPopUntil(
                AppRoutes.mainHomeScreen,
                context,
              );
            } else if (state is Error)
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
          },
          child: TextButton(
            child: Text(AppStrings.share,
                style: TextStyle(color: AppColors.black)),
            onPressed: _onShareTapped,
          ),
        )
      ],
    );
  }
}
