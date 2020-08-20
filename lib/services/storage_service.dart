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
  final _postsRef = Firestore.instance
      .collection('posts')
      .document(Data.defaultUser.id)
      .collection('userPosts')
      .document();

  final _timeLineRef = Firestore.instance
      .collection('timeline')
      .document(Data.defaultUser.id)
      .collection('timelinePosts')
      .document();

  final _usersRef = Firestore.instance
      .collection('users')
      .document(Data.defaultUser.id);
  SharedPreferences prefs;

  Future uploadFile({@required File selectedFile, bool isProfilePhoto = false}) async {
    String folder;
    isProfilePhoto ? folder = 'profilePhotos' : folder = 'posts';

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('$folder/${Path.basename(selectedFile.path)}}');

    StorageUploadTask uploadTask = storageReference.putFile(selectedFile);
    await uploadTask.onComplete;
    final fileURL = await storageReference.getDownloadURL();
    return fileURL;

  }

  Future getImage(ImageSource source) async {
//    this.setState(() {
//      _inProcess = true;
//    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
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
      _usersRef.updateData({
        'photoUrl': fileURL,
      });

      prefs = await SharedPreferences.getInstance();
      prefs.setString('photoUrl', fileURL);
    } else {
      final postId = await _postsRef.get();

      await _postsRef.setData({
        'name': Data.defaultUser.userName,
        'caption': caption,
        'photoUrl': fileURL,
        'timestamp': timestamp,
        'postId': postId.documentID,
        'publisherId': Data.defaultUser.id,
        "likes": [],
        'publisherProfilePhoto': Data.defaultUser.photoUrl
      });
      // add post to timeline of post owner
      await _timeLineRef.setData({
        'name': Data.defaultUser.userName,
        'caption': caption,
        'photoUrl': fileURL,
        'timestamp': timestamp,
        'postId': postId.documentID,
        "likes": [],
        'publisherId': Data.defaultUser.id,
        'publisherProfilePhoto': Data.defaultUser.photoUrl
      });

    }
  }
}
