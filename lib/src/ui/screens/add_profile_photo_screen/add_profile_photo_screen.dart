import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';

import '../../../../router.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  @override
  _AddProfilePhotoScreenState createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  pickAndSaveProfileImage(ImageSource source) async {
    Navigator.pop(context);
    context.read<AuthBloc>().add(PickProfilePhotoTapped(source));
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
          if (state is ProfileImagePicked)
            NavigationUtils.pushNamed(
                route: AppRoutes.profilePhotoAddedScreen, context: context);
          print("state is $state");
        },
        child: Container(
          padding: EdgeInsets.only(top: 10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                Icons.add_a_photo,
                size: 80,
              ),
              Text(
                'Add Profile Photo',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'Add a profile photo so your friends know it\'s you',
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 42,
                child: RaisedButton(
                  onPressed: () {
                    _showPickImageDialogue(context);
                  },
                  child: Text(
                    'Add a photo',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Colors.blue,
                ),
              ),
              FlatButton(
                child: Text('Skip',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                onPressed: onSkipTapped,
              )
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
                Text("Change Profile Photo"),
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
                  'Take Photo',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SimpleDialogOption(
                  onPressed: () => pickAndSaveProfileImage(ImageSource.gallery),
                  child: Text(
                    'Choose from Library',
                    style: TextStyle(fontSize: 17),
                  )),
            ],
          );
        });
  }
}
