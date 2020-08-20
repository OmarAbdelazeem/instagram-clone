import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/models/app_flow.dart';
import 'package:instagramapp/pages/notification.dart';
import 'package:instagramapp/pages/profile_components/my_profile.dart';
import 'package:instagramapp/pages/search.dart';
import 'package:instagramapp/pages/search_photos.dart';
import 'package:instagramapp/pages/time_line.dart';
import 'package:instagramapp/pages/upload.dart';
import 'package:instagramapp/services/navigation_functions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  String homeLink = 'assets/images/home_light.svg';
  String searchLink= 'assets/images/search_light.svg';
//  static List keys = [
//    ,
//    GlobalKey<ScaffoldState>(),
//    GlobalKey<ScaffoldState>(),
//    GlobalKey<ScaffoldState>(),
//    GlobalKey<ScaffoldState>(),
//  ];

//  var currentFlow;
//  static List<AppFlow> keys = [
//    AppFlow(
//      iconData: Icons.home,
//      navigatorKey: GlobalKey<NavigatorState>(),
//    ),
//    AppFlow(
//      iconData: Icons.search,
//      navigatorKey: GlobalKey<NavigatorState>(),
//    ),
//    AppFlow(
//      iconData: Icons.add_to_queue,
//      navigatorKey: GlobalKey<NavigatorState>(),
//    ),
//    AppFlow(
//      iconData: Icons.favorite_border,
//      navigatorKey: GlobalKey<NavigatorState>(),
//    ),
//    AppFlow(
//      iconData: Icons.person_pin,
//      navigatorKey: GlobalKey<NavigatorState>(),
//    ),
//  ];

  final List<Widget> _children = [
    TimeLine(
//      navigatorKey: keys[0],
        ),
    SearchPhotos(
//      navigatorKey: keys[1],
        ),
    Container(),
    ActivityFeed(
//      navigatorKey: keys[2],
        ),
    MyProfile(
//      navigatorKey: keys[3],
        )
  ];

  @override
  Widget build(BuildContext context) {
//    GlobalKey<NavigatorState> currentKey;
//    if(_currentIndex !=2)
    final currentKey = GlobalKey<NavigatorState>();

    return WillPopScope(
        onWillPop: () async => !await currentKey.currentState.maybePop(),
        child: Scaffold(
          body: IndexedStack(index: _currentIndex, children: _children),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black87,
            backgroundColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            },
            items: [
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
          'assets/images/home_dark.svg',
            height: 25,
            width: 25,
          ),
                icon: SvgPicture.asset(
                'assets/images/home_light.svg',
                  height: 25,
                  width: 25,
                ),
//                Icon(
//                  Icons.home,
//                  size: 30,
//                ),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
              'assets/images/search_dark.svg',
              height: 25,
              width: 25,
              ),
                icon: SvgPicture.asset(
                  'assets/images/search_light.svg',
                  height: 25,
                  width: 25,
                ),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),
              ),
              BottomNavigationBarItem(

                icon: GestureDetector(
                  onTap: () {
                    NavigationFunctions.pushPage(
                        context: context,
                        page: Upload(),
                        isHorizontalNavigation: false);
                  },
                  child: SvgPicture.asset('assets/images/add.svg',width: 24,height: 24,),
                ),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.favorite,
                  size: 30,
                ),
                icon: Icon(
                  Icons.favorite_border,
                  size: 30,
                ),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                ),
              ),
            ],
          ),
        ));
  }
}
