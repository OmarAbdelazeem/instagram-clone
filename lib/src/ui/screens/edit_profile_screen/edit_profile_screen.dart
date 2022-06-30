import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/router.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import '../../../core/utils/loading_dialogue.dart';
import '../../../models/user_model/user_model.dart';
import '../../common/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController nameController;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late TextEditingController bioController;
  late AuthBloc authBloc;

  UserModel user = UserModel(
      photoUrl:
          "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
      userName: "Omar Abdelazeem",
      bio: "this is a bio",
      id: "123",
      email: "omar@email.com",
      postsCount: 1,
      followersCount: 3,
      followingCount: 5,
      //Todo fix this
      timestamp: (Timestamp.now()).toDate());

  @override
  void initState() {
    nameController = TextEditingController(text: user.userName);
    bioController = TextEditingController(text: user.bio);
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  Widget _buildNameField() {
    return IgnorePointer(
      child: AppTextField(
        controller: nameController,
        fillColor: AppColors.scaffoldBackgroundColor,
        // hintText: AppStrings.updateName,
        labelText: AppStrings.name,
      ),
    );
  }

  Widget buildBioField() {
    return IgnorePointer(
      child: AppTextField(
        controller: bioController,
        fillColor: AppColors.scaffoldBackgroundColor,
        // hintText: AppStrings.bio,
        labelText: AppStrings.bio,
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
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ProfilePhoto(radius: 34),
            TextButton(
              child: Text(AppStrings.changeProfilePhoto,
                  style: AppTextStyles.defaultTextStyleNormal.copyWith(
                      color: AppColors.blue, fontWeight: FontWeight.w500)),
              onPressed: () {},
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
        listener: (context, state) {
          if (state is LoggingOut)
            showLoadingDialog(context, _keyLoader);
          else if (state is UserLoggedOut) {
            print("_keyLoader.currentContext! is ${_keyLoader.currentContext!}");
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            // NavigationUtils.pushNamedAndPopUntil(AppRoutes.authScreen, context);
          } else if (state is Error) {
            //Todo show alert here
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        },
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
}
