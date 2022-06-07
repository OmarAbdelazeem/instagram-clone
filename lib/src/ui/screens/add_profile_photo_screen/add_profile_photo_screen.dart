import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import '../../../../router.dart';
import '../../../core/utils/image_utils.dart';
import '../../common/loading_dialogue.dart';


class AddProfilePhotoScreen extends StatefulWidget {
  @override
  _AddProfilePhotoScreenState createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  pickAndSaveProfileImage(ImageSource source) async {
    //Todo fix this as before
    // Navigator.pop(context);
    // final imageFile = await ImageUtils.pickImage(source);
    // if(imageFile!=null)
    // context.read<AuthBloc>().add(ProfilePhotoPicked(imageFile));
  }

  onSkipTapped() {
    NavigationUtils.pushNamed(
        route: AppRoutes.peopleSuggestionsScreen, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is Loading) showLoadingDialog(context, _keyLoader);
          if (state is ProfilePhotoUploaded) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            NavigationUtils.pushNamed(
                route: AppRoutes.profilePhotoAddedScreen,
                context: context,
                arguments: state.imageUrl);
          } else if (state is Error)
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.add_a_photo,
                size: 80,
              ),
              Text(
                AppStrings.addProfilePhoto,
                style: TextStyle(fontSize: 30),
              ),
              Text(
                AppStrings.addProfilePhotoSoYourFriends,
              ),
              AppButton(
                title: AppStrings.addAPhoto,
                width: double.infinity,
                onTap: () => _showPickImageDialogue(context),
              ),
              AppButton(
                title: AppStrings.skip,
                width: double.infinity,
                color: AppColors.scaffoldBackgroundColor,
                titleStyle: TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                onTap: onSkipTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showPickImageDialogue(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Column(
              children: <Widget>[
                Text(AppStrings.changeProfilePhoto),
                SizedBox(
                  height: 10,
                ),
                Divider()
              ],
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => pickAndSaveProfileImage(ImageSource.camera),
                child: Text(
                  AppStrings.takePhoto,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SimpleDialogOption(
                  onPressed: () => pickAndSaveProfileImage(ImageSource.gallery),
                  child: Text(
                    AppStrings.chooseFromLibrary,
                    style: TextStyle(fontSize: 17),
                  )),
            ],
          );
        });
  }
}
