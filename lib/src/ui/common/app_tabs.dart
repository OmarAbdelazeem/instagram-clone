import 'package:flutter/material.dart';

import '../../res/app_colors.dart';

class AppTabs extends StatefulWidget {
  final List<AppTabItemModel> items;
  final Function(int index) onItemChanged;
  final int selectedIndex;

  AppTabs(
      {required this.items,
      required this.onItemChanged,
      required this.selectedIndex});

  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < widget.items.length; i++)
          Expanded(
            child: _buildTapItem(i, widget.items[i]),
          )
      ],
    );
  }

  Widget _buildTapItem(int index, AppTabItemModel appTabItem) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onItemChanged(index);
        });
      },
      child: Column(
        children: <Widget>[
          index == widget.selectedIndex
              ? appTabItem.selectedItem
              : appTabItem.unSelectedItem,
          Divider(
            thickness: index == widget.selectedIndex ? 1 : 0.5,
            color: index == widget.selectedIndex ? AppColors.black : AppColors.grey,
          )
        ],
      ),
    );
  }
}

class AppTabItemModel {
  final Widget selectedItem;
  final Widget unSelectedItem;

  AppTabItemModel({required this.selectedItem, required this.unSelectedItem});
}
