import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/core/utils/image_utils.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import '../../../../../router.dart';
import '../../../../res/app_images.dart';

class TimelineActionsDropDown extends StatefulWidget {
  @override
  _TimelineActionsDropDownState createState() =>
      _TimelineActionsDropDownState();
}

class _TimelineActionsDropDownState extends State<TimelineActionsDropDown> {
  String? _dropDownValue;
  XFile? _imageFile;

  List<DropDownItemModel> items = [
    DropDownItemModel(title: AppStrings.post, icon: Icons.grid_on),
    DropDownItemModel(title: AppStrings.story, icon: Icons.add_circle_outline),
    DropDownItemModel(title: AppStrings.reel, icon: Icons.video_library),
    DropDownItemModel(title: AppStrings.live, icon: Icons.wifi_tethering),
  ];

  void pickImage() async {
    ImageUtils.pickImage(ImageSource.gallery).then((value) {
      setState(() {
        _imageFile = value;
      });
      if (_imageFile != null) {
        NavigationUtils.pushNamed(
            route: AppRoutes.newPostScreen,
            context: context,
            arguments: _imageFile);
      }
    });
  }

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
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.add_box_outlined)),
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
