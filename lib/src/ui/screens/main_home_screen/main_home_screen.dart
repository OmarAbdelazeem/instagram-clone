import 'package:flutter/material.dart';
import 'package:instagramapp/src/ui/screens/activity_screen/activity_screen.dart';
import 'package:instagramapp/src/ui/screens/explore_photos_screen/explore_photos_screen.dart';
import 'package:instagramapp/src/ui/screens/main_home_screen/widgets/app_bottom_navigation_bar.dart';
import '../../../res/app_images.dart';
import '../profile_screen/my_profile_screen.dart';
import '../search_screen/search_screen.dart';
import '../time_line_screen/time_line_screen.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    TimeLineScreen(),
    ExplorePhotosScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];
  final List<BottomNavigationBarItemModel> bottomNavigationBarItems = [
    BottomNavigationBarItemModel(
        svgPath: AppImages.homeFilledSvg,),
    BottomNavigationBarItemModel(
        svgPath: AppImages.searchFilledSvg,),
    BottomNavigationBarItemModel(
        svgPath: AppImages.heartOutlineSvg,),
    BottomNavigationBarItemModel(
        svgPath: AppImages.personSvg,),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPopScope,
        child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: _screens),
            bottomNavigationBar: _buildBottomNavigationBar()));
  }

  Widget _buildBottomNavigationBar() {
    return AppBottomNavigationBar(
      items: bottomNavigationBarItems,
      selectedIndex: _currentIndex,
      onItemChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Future<bool> _onWillPopScope() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    } else {
      return true;
    }
  }
}
