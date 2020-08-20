import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/pages/sign_up/profile_photo_added.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/storage_service.dart';

import '../people_suggestion.dart';

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  StorageService storageService = StorageService();
  File _selectedPhoto;

  handleImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      _selectedPhoto = await storageService.getImage(ImageSource.camera);
      print('_selectedFile is $_selectedPhoto');
    } else if (source == ImageSource.gallery) {
      _selectedPhoto = await storageService.getImage(ImageSource.gallery);
      print('_selectedFile is $_selectedPhoto');
    }

    if (_selectedPhoto != null) {
      final photoUrl =
          await storageService.uploadFile(selectedFile: _selectedPhoto,isProfilePhoto: true);
      await storageService.setPhotoData(
          isProfilePhoto: true, fileURL: photoUrl);
      NavigationFunctions.navigateToPageAndRemoveRoot(
          context, ProfilePhotoAdded(_selectedPhoto),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        crossAxisAlignment: CrossAxisAlignment.center,
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
//          style: TextStyle(fontSize: 30),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 42,
              child: RaisedButton(
                onPressed: () {
                  handleProfilePhoto(context);
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
              onPressed: () {
                print('_selectedFile is $_selectedPhoto');
                NavigationFunctions.navigateToPageAndRemoveRoot(
                    context, PeopleSuggestion());
              },
            )
          ],
        ),
      ),
    );
  }

  handleProfilePhoto(BuildContext parentContext) {
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
                onPressed: () {
                  Navigator.pop(context);
                  handleImage(ImageSource.camera);
                },
                child: Text(
                  'Take Photo',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    handleImage(ImageSource.gallery);
                  },
                  child: Text(
                    'Choose from Library',
                    style: TextStyle(fontSize: 17),
                  )),
            ],
          );
        });
  }
}
