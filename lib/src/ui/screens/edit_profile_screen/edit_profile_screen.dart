import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/update_field_screen/update_field_screen.dart';
import '../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/loading_dialogue.dart';
import '../../../models/user_model/user_model.dart';
import '../../common/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late TextEditingController bioController;
  LoggedInUserBloc? loggedInUserBloc;
  late AuthBloc authBloc;

  @override
  void initState() {
    loggedInUserBloc = context.read<LoggedInUserBloc>();

    nameController =
        TextEditingController(text: loggedInUserBloc!.loggedInUser!.userName!);
    bioController =
        TextEditingController(text: loggedInUserBloc!.loggedInUser!.bio!);
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  Widget _buildNameField() {
    return InkWell(
      onTap: () async {
        final name = await NavigationUtils.pushScreen(
            screen: UpdateFieldScreen(
                title: AppStrings.name,
                value: loggedInUserBloc!.loggedInUser!.userName!),
            context: context);
        if (name != null) {
          setState(() {
            nameController = TextEditingController(text: name);
          });
        }
      },
      child: IgnorePointer(
        child: AppTextField(
          controller: nameController,
          fillColor: AppColors.scaffoldBackgroundColor,
          // hintText: AppStrings.updateName,
          labelText: AppStrings.name,
        ),
      ),
    );
  }

  Widget buildBioField() {
    return InkWell(
      onTap: () async {
        final bio = await NavigationUtils.pushScreen(
            screen: UpdateFieldScreen(
                title: AppStrings.bio,
                value: loggedInUserBloc!.loggedInUser!.bio!),
            context: context);
        if(bio!=null){
          setState((){
            bioController = TextEditingController(text: bio);

          });
        }
      },
      child: IgnorePointer(
        child: AppTextField(
          controller: bioController,
          fillColor: AppColors.scaffoldBackgroundColor,
          labelText: AppStrings.bio,
        ),
      ),
    );
  }

  updateProfileData() {
    Navigator.pop(context);
    // setState(() {
    //   displayNameController.text.trim().length < 3 ||
    //           displayNameController.text.isEmpty
    //       ? _displayNameValid = false
    //       : _displayNameValid = true;
    //   bioController.text.trim().length > 100
    //       ? _bioValid = false
    //       : _bioValid = true;
    // });
    //
    // if (_displayNameValid && _bioValid) {
    //   usersRef.doc(Data.defaultUser.id).update({
    //     "displayName": displayNameController.text,
    //     "bio": bioController.text,
    //   });
    //   SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
    //   _scaffoldKey.currentState.showSnackBar(snackbar);
    //   Navigator.pop(context);
    // }
  }

  logout() async {
    context.read<AuthBloc>().add(LogoutStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            BlocConsumer<AuthBloc, AuthState>(
                bloc: authBloc,
                listener: (context, state) {
                  if (state is Loading) showLoadingDialog(context, _keyLoader);
                  if (state is ProfilePhotoUploaded) {
                    Navigator.of(_keyLoader.currentContext!).pop();
                    Navigator.pop(context);
                  } else if (state is Error)
                    Navigator.of(_keyLoader.currentContext!).pop();
                },
                builder: (context, state) {
                  return ProfilePhoto(
                    radius: 34,
                    photoUrl: loggedInUserBloc!.loggedInUser!.photoUrl!,
                  );
                }),
            TextButton(
              child: Text(AppStrings.changeProfilePhoto,
                  style: AppTextStyles.defaultTextStyleNormal.copyWith(
                      color: AppColors.blue, fontWeight: FontWeight.w500)),
              onPressed: () => _pickAndSaveProfileImage(ImageSource.gallery),
            ),
            SizedBox(
              height: 12,
            ),
            _buildNameField(),
            Divider(),
            SizedBox(
              height: 12,
            ),
            buildBioField(),
            Divider(),
            _buildLogoutButton()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.editProfile,
        style: AppTextStyles.appBarTitleStyle,
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: updateProfileData,
        icon: Icon(
          Icons.close_sharp,
          size: 30.0,
          // color: Colors.blue,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: updateProfileData,
          icon: Icon(
            Icons.done,
            size: 30.0,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: _logoutListener,
        builder: (context, state) {
          return AppButton(
            title: AppStrings.logout,
            titleStyle: AppTextStyles.defaultTextStyleBold
                .copyWith(color: AppColors.blue),
            color: AppColors.scaffoldBackgroundColor,
            borderColor: AppColors.scaffoldBackgroundColor,
            onTap: () {
              authBloc.add(LogoutStarted());
            },
          );
        });
  }

  void _logoutListener(BuildContext context, state) async {
    if (state is LoggingOut)
      showLoadingDialog(context, _keyLoader);
    else if (state is UserLoggedOut) {
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      NavigationUtils.pushNamedAndPopUntil(AppRoutes.authScreen, context);
    } else if (state is Error) {
      //Todo show alert here
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  _pickAndSaveProfileImage(ImageSource source) async {
    //Todo fix this as before
    Navigator.pop(context);
    final imageFile = await ImageUtils.pickImage(source);
    if (imageFile != null) authBloc.add(ProfilePhotoPicked(imageFile));
  }
}
