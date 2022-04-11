import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/data/data.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramapp/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final DateTime timestamp = DateTime.now();
  final _postsRef = FirebaseFirestore.instance
      .collection('posts')
      .doc(Data.defaultUser.searchedUserId)
      .collection('userPosts')
      .doc();

  final _timeLineRef = FirebaseFirestore.instance
      .collection('timeline')
      .doc(Data.defaultUser.searchedUserId)
      .collection('timelinePosts')
      .doc();

  final _usersRef = FirebaseFirestore.instance
      .collection('users')
      .doc(Data.defaultUser.searchedUserId);
  SharedPreferences prefs;

  Future uploadFile({required File selectedFile, bool isProfilePhoto = false}) async {
    String folder;
    isProfilePhoto ? folder = 'profilePhotos' : folder = 'posts';

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$folder/${Path.basename(selectedFile.path)}}');

    var uploadTask = storageReference.putFile(selectedFile);
    await uploadTask;
    // await uploadTask.onComplete;
    final fileURL = await storageReference.getDownloadURL();
    return fileURL;

  }

  Future getImage(ImageSource source) async {
//    this.setState(() {
//      _inProcess = true;
//    });
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          ));
      return cropped;

//      this.setState(() {
//        _selectedFile = cropped;
//        _inProcess = false;
//      });
//    } else {
//      this.setState(() {
//        _inProcess = false;
//      });
//    }
    }
  }

  Future setPhotoData(
      {String caption, String fileURL, bool isProfilePhoto}) async {
    if (isProfilePhoto) {
      _usersRef.update({
        'photoUrl': fileURL,
      });

      prefs = await SharedPreferences.getInstance();
      prefs.setString('photoUrl', fileURL);
    } else {
      final postId = await _postsRef.get();

      await _postsRef.set({
        'name': Data.defaultUser.userName,
        'caption': caption,
        'photoUrl': fileURL,
        'timestamp': timestamp,
        'postId': postId.id,
        'publisherId': Data.defaultUser.searchedUserId,
        "likes": [],
        'publisherProfilePhoto': Data.defaultUser.photoUrl
      });
      // add post to timeline of post owner
      await _timeLineRef.set({
        'name': Data.defaultUser.userName,
        'caption': caption,
        'photoUrl': fileURL,
        'timestamp': timestamp,
        'postId': postId.id,
        "likes": [],
        'publisherId': Data.defaultUser.searchedUserId,
        'publisherProfilePhoto': Data.defaultUser.photoUrl
      });

    }
  }
}
