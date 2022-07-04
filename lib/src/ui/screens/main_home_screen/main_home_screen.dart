import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/ui/screens/activity_screen/activity_screen.dart';
import 'package:instagramapp/src/ui/screens/explore_photos_screen/explore_photos_screen.dart';
import 'package:instagramapp/src/ui/screens/main_home_screen/widgets/app_bottom_navigation_bar.dart';
import '../../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import '../../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit_state.dart';
import '../../../bloc/firebase_notifications_bloc/firebase_notifications_bloc.dart';
import '../../../res/app_images.dart';
import '../profile_screen/my_profile_screen.dart';
import '../search_screen/search_screen.dart';
import '../time_line_screen/time_line_screen.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late BottomNavigationBarCubit bottomNavigationBarCubit;
  late FirebaseNotificationsBloc notificationsBloc;
  final List<Widget> _screens = [
    TimeLineScreen(),
    ExplorePhotosScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  final List<BottomNavigationBarItemModel> bottomNavigationBarItems = [
    BottomNavigationBarItemModel(
      svgPath: AppImages.homeFilledSvg,
    ),
    BottomNavigationBarItemModel(
      svgPath: AppImages.searchFilledSvg,
    ),
    BottomNavigationBarItemModel(
      svgPath: AppImages.heartOutlineSvg,
    ),
    BottomNavigationBarItemModel(
      svgPath: AppImages.personSvg,
    ),
  ];

  @override
  void initState() {
    bottomNavigationBarCubit = context.read<BottomNavigationBarCubit>();
    notificationsBloc = context.read<FirebaseNotificationsBloc>();
    notificationsBloc.add(ListenToForMessageOpeningAppStarted());
    notificationsBloc.add(ListenToForGroundMessageStarted());
    notificationsBloc.add(ListenToTokenStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseNotificationsBloc, FirebaseNotificationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocBuilder<BottomNavigationBarCubit,
            BottomNavigationBarCubitState>(
          builder: (context, state) {
            return WillPopScope(
                onWillPop: _onWillPopScope,
                child: Scaffold(
                    body: IndexedStack(
                        index: bottomNavigationBarCubit.currentIndex,
                        children: _screens),
                    bottomNavigationBar: _buildBottomNavigationBar()));
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return AppBottomNavigationBar(
      items: bottomNavigationBarItems,
      selectedIndex: bottomNavigationBarCubit.currentIndex,
      onItemChanged: (index) {
        bottomNavigationBarCubit.changeCurrentScreen(index);
      },
    );
  }

  Future<bool> _onWillPopScope() async {
    if (bottomNavigationBarCubit.currentIndex > 0) {
      bottomNavigationBarCubit.changeCurrentScreen(0);
      return false;
    } else {
      return true;
    }
  }
}
