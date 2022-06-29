import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/views/followers_view.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/views/following_view.dart';

import '../../../repository/data_repository.dart';

class FollowingAndFollowersScreen extends StatefulWidget {
  const FollowingAndFollowersScreen({Key? key}) : super(key: key);

  @override
  State<FollowingAndFollowersScreen> createState() =>
      _FollowingAndFollowersScreenState();
}

class _FollowingAndFollowersScreenState
    extends State<FollowingAndFollowersScreen> {
  late LoggedInUserBloc loggedInUserBloc;
  late UsersBloc usersBloc;

  @override
  void initState() {
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    final dataRepository = context.read<DataRepository>();
    usersBloc = UsersBloc(dataRepository, loggedInUserBloc.loggedInUser!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocProvider<UsersBloc>(
            create: (_) => usersBloc,
            child: TabBarView(
              children: [
                FollowersScreen(usersBloc: usersBloc),
                FollowingScreen(usersBloc: usersBloc),
              ],
            )),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: TabBar(
        indicatorColor: AppColors.black,
        tabs: [
          Tab(
              icon: Text(
            "${loggedInUserBloc.loggedInUser!.followersCount} ${AppStrings.followers}",
            style: AppTextStyles.defaultTextStyleBold,
          )),
          Tab(
              icon: Text(
            "${loggedInUserBloc.loggedInUser!.followingCount} ${AppStrings.following}",
            style: AppTextStyles.defaultTextStyleBold,
          )),
        ],
      ),
      title: Text(loggedInUserBloc.loggedInUser!.userName!,
          style: AppTextStyles.appBarTitleStyle),
    );
  }
}
