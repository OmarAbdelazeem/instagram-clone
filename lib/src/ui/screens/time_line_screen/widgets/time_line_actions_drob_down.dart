import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/core/utils/image_utils.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../../router.dart';

class TimelineActionsDropDown extends StatefulWidget {
  @override
  _TimelineActionsDropDownState createState() =>
      _TimelineActionsDropDownState();
}

class _TimelineActionsDropDownState extends State<TimelineActionsDropDown> {
  XFile? _imageFile;

  List<DropDownItemModel> items = [
    DropDownItemModel(title: AppStrings.post, icon: Icons.grid_on),
    DropDownItemModel(title: AppStrings.story, icon: Icons.add_circle_outline),
    DropDownItemModel(title: AppStrings.reel, icon: Icons.video_library),
    DropDownItemModel(title: AppStrings.live, icon: Icons.wifi_tethering),
  ];

  void pickImage() async {
    ImageUtils.pickImage(ImageSource.gallery).then((value) async {
      setState(() {
        _imageFile = value;
      });
      if (_imageFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          compressFormat: ImageCompressFormat.png,
          compressQuality: 80,

          // androidUiSettings: AndroidUiSettings(
          //   toolbarTitle: 'Cropper',
          //   toolbarColor: Colors.deepOrange,
          //   toolbarWidgetColor: Colors.white,
          //   initAspectRatio: CropAspectRatioPreset.original,
          // ),
          // iosUiSettings: IOSUiSettings(
          //   title: 'Cropper',
          // ),
        );
        if (croppedFile != null) {

          NavigationUtils.pushNamed(
              route: AppRoutes.newPostScreen,
              context: context,
              arguments: croppedFile);
        }
      }
    });
  }

  // void pickVideo() async {
  //   XFile? videoFile = await ImageUtils.pickVideo(ImageSource.gallery);
  //   //Todo implement crop video functions here
  //   if (videoFile != null) {
  //     await ImageCropper().cropImage(
  //       sourcePath: videoFile.path,
  //       aspectRatioPresets: [
  //         CropAspectRatioPreset.square,
  //       ],
  //       aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
  //       compressFormat: ImageCompressFormat.png,
  //       compressQuality: 80,
  //       // androidUiSettings: AndroidUiSettings(
  //       //   toolbarTitle: 'Cropper',
  //       //   toolbarColor: Colors.deepOrange,
  //       //   toolbarWidgetColor: Colors.white,
  //       //   initAspectRatio: CropAspectRatioPreset.original,
  //       // ),
  //       // iosUiSettings: IOSUiSettings(
  //       //   title: 'Cropper',
  //       // ),
  //     );
  //   }
  // }

  void onChanged(String? val) {
    // Todo implement all functions
    switch (val) {
      case AppStrings.post:
        pickImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: Padding(
          padding: EdgeInsets.only(top: 7),
          child: Icon(
            Icons.add_box_outlined,
            color: Colors.black,
          )),
      underline: Container(),
      items: items.map(
        (val) {
          return DropdownMenuItem<String>(
            value: val.title,
            child: _buildDropDownItem(val.title, val.icon),
          );
        },
      ).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDropDownItem(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Icon(icon)],
    );
  }
}

class DropDownItemModel {
  String title;
  IconData icon;

  DropDownItemModel({required this.icon, required this.title});
}
