import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/ui/screens/activity_screen/activity_screen.dart';
import 'package:instagramapp/src/ui/screens/main_home_screen/widgets/app_bottom_navigation_bar.dart';
import '../../../bloc/activities_bloc/activities_bloc.dart';
import '../../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import '../../../bloc/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit_state.dart';
import '../../../bloc/explore_posts_bloc/explore_posts_bloc.dart';
import '../../../bloc/firebase_notifications_bloc/firebase_notifications_bloc.dart';
import '../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../../../bloc/posts_bloc/posts_bloc.dart';
import '../../../bloc/time_line_bloc/time_line_bloc.dart';
import '../../../repository/data_repository.dart';
import '../../../repository/posts_repository.dart';
import '../../../res/app_images.dart';
import '../explore_posts_screen/explore_posts_screen.dart';
import '../profile_screen/my_profile_screen.dart';
import '../time_line_screen/time_line_screen.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  late BottomNavigationBarCubit bottomNavigationBarCubit;
  late TimeLineBloc timeLineBloc;
  late ExplorePostsBloc explorePostsBloc;
  late ActivitiesBloc activitiesBloc;
  late LoggedInUserBloc loggedInUserBloc;
  late FirebaseNotificationsBloc notificationsBloc;
  late PageController pageController;
  List<Widget> _screens = [];

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
    setUpScreens();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  void setUpScreens() {
    final dataRepository = context.read<DataRepository>();

    final postsBloc = context.read<PostsBloc>();

    bottomNavigationBarCubit = context.read<BottomNavigationBarCubit>();

    notificationsBloc = context.read<FirebaseNotificationsBloc>();

    notificationsBloc.add(ListenToForMessageOpeningAppStarted());
    notificationsBloc.add(ListenToForGroundMessageStarted());
    notificationsBloc.add(ListenToTokenStarted());
    timeLineBloc = TimeLineBloc(dataRepository, postsBloc);

    explorePostsBloc = ExplorePostsBloc(postsBloc, dataRepository);
    explorePostsBloc.add(FetchExplorePostsStarted(false));
    activitiesBloc = ActivitiesBloc(
        context.read<DataRepository>(), context.read<UsersBloc>());
    activitiesBloc.add(FetchActivitiesStarted(false));
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    loggedInUserBloc.add(FetchLoggedInUserPostsStarted(false));
    loggedInUserBloc.add(ListenToLoggedInUserStarted());
    pageController =
        PageController(initialPage: bottomNavigationBarCubit.currentIndex);
    _screens = [
      TimeLineScreen(timeLineBloc),
      ExplorePostsScreen(explorePostsBloc),
      ActivityScreen(activitiesBloc),
      ProfileScreen(loggedInUserBloc),
    ];

    timeLineBloc.add(FetchTimeLinePostsStarted(false));

    timeLineBloc.add(ListenToTimelinePostsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseNotificationsBloc, FirebaseNotificationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<BottomNavigationBarCubit,
            BottomNavigationBarCubitState>(
          listener: (context, state) {
            if (state is BottomNavigationBarChanged) {
              pageController.jumpToPage(bottomNavigationBarCubit.currentIndex);
            }
          },
          builder: (context, state) {
            return WillPopScope(
                onWillPop: _onWillPopScope,
                child: Scaffold(
                    body: _buildPageView(),
                    bottomNavigationBar: _buildBottomNavigationBar()));
          },
        );
      },
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: _screens,
    );
  }

  Widget _buildBottomNavigationBar() {
    return AppBottomNavigationBar(
      items: bottomNavigationBarItems,
      selectedIndex: bottomNavigationBarCubit.currentIndex,
      onItemChanged: (index) {
        pageController.jumpToPage(index);
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
