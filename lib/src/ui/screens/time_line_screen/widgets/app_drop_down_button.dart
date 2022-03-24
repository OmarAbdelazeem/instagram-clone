import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../res/app_images.dart';

class AppDropDownButton extends StatefulWidget {
  @override
  _AppDropDownButtonState createState() => _AppDropDownButtonState();
}

class _AppDropDownButtonState extends State<AppDropDownButton> {
  String? _dropDownValue;
  List<DropDownItemModel> items = [
    DropDownItemModel(title: "Post", icon: Icons.grid_on),
    DropDownItemModel(title: "Story", icon: Icons.add_circle_outline),
    DropDownItemModel(title: "Reel", icon: Icons.video_library),
    DropDownItemModel(title: "Live", icon: Icons.wifi_tethering),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: SvgPicture.asset(
        AppImages.addSvg,
        width: 20,
        height: 20,
      ),
      underline: Container(),
      items: items.map(
        (val) {
          return DropdownMenuItem<String>(
            value: val.title,
            child: _buildDropDownItem(val.title,val.icon),
          );
        },
      ).toList(),
      onChanged: (val) {
        setState(
          () {
            // _dropDownValue = val;
          },
        );
      },
    );
  }

  Widget _buildDropDownItem(String title, IconData icon) {
    return Row(
      children: [Text(title), Icon(icon)],
    );
  }
}

class DropDownItemModel {
  String title;
  IconData icon;

  DropDownItemModel({required this.icon, required this.title});
}
