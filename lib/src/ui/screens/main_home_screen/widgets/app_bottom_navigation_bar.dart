import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../res/app_colors.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final List<BottomNavigationBarItemModel> items;
  final Function(int index) onItemChanged;
  final int selectedIndex;

  const AppBottomNavigationBar(
      {Key? key,
      required this.items,
      required this.onItemChanged,
      required this.selectedIndex})
      : super(key: key);

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,),
        child: Column(
          children: [
            Divider(),
            SizedBox(height: 5,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    buildBottomNavigationBarItem(
                        i, widget.items[i].svgPath, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavigationBarItem(
      int index, String svgPath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onItemChanged(index);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            height: 20,
            width: 21,
            color: widget.selectedIndex == index
                ? AppColors.black
                : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarItemModel {
  String? title;
  String svgPath;

  BottomNavigationBarItemModel(
      {this.title,
      required this.svgPath,});
}
