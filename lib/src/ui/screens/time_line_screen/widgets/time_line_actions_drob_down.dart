import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/core/utils/image_utils.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../../router.dart';

class TimelineActionsDropList extends StatefulWidget {
  @override
  _TimelineActionsDropListState createState() =>
      _TimelineActionsDropListState();
}

class _TimelineActionsDropListState extends State<TimelineActionsDropList> {
  XFile? _imageFile;
  String _selectedMenu = '';

  List<DropListItemModel> items = [
    DropListItemModel(title: AppStrings.post, icon: Icons.grid_on),
    DropListItemModel(title: AppStrings.story, icon: Icons.add_circle_outline),
    DropListItemModel(title: AppStrings.reel, icon: Icons.video_library),
    DropListItemModel(title: AppStrings.live, icon: Icons.wifi_tethering),
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

  void onItemTapped(String title) {
    switch (title) {
      case AppStrings.post:
        pickImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildDropList();
  }

  Row _buildDropDownItem(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Icon(icon)],
    );
  }

  _buildDropList() {
    return PopupMenuButton<DropListItemModel>(
        icon: Icon(
          Icons.add_box_outlined,
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context) => items
            .map((DropListItemModel e) => PopupMenuItem<DropListItemModel>(
                onTap: () => onItemTapped(e.title),
                child: _buildDropDownItem(e.title, e.icon)))
            .toList());
  }
}

class DropListItemModel {
  String title;
  IconData icon;

  DropListItemModel({required this.icon, required this.title});
}
