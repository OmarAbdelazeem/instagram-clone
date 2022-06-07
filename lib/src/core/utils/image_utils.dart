import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      return pickedFile;
    } catch (e) {
      print("error is $e");
    }
    return null;
  }

  cropImage(String sourcePath) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        // androidUiSettings: AndroidUiSettings(
        //   toolbarColor: Colors.deepOrange,
        //   toolbarTitle: "RPS Cropper",
        //   statusBarColor: Colors.deepOrange.shade900,
        //   backgroundColor: Colors.white,
        // )
    );
    return cropped;
  }

  static Future<XFile?> pickVideo(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      return pickedFile;
    } catch (e) {
      print("error is $e");
    }
    return null;
  }
}
