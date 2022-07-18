import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/followers_bloc/followers_bloc.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/views/followers_view.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/views/following_view.dart';

import '../../../repository/data_repository.dart';

class FollowingAndFollowersScreen extends StatefulWidget {

  final UserModel user;
  final int initialIndex;

  const FollowingAndFollowersScreen({Key? key,

    required this.user,
    required this.initialIndex})
      : super(key: key);

  @override
  State<FollowingAndFollowersScreen> createState() =>
      _FollowingAndFollowersScreenState();
}

class _FollowingAndFollowersScreenState
    extends State<FollowingAndFollowersScreen> {
  late LoggedInUserBloc loggedInUserBloc;
  late FollowersBloc followersBloc;
  late FollowingBloc followingBloc;

  Future<void> fetchFollowers(bool nextList) async {
    followersBloc.add(FetchFollowersStarted(nextList));
  }

  Future<void> fetchFollowing(bool nextList) async {
    followingBloc.add(FetchFollowingUsersStarted(nextList));
  }

  @override
  void initState() {
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    final dataRepository = context.read<DataRepository>();
    followersBloc =
        FollowersBloc(dataRepository, context.read<UsersBloc>(), widget.user.id!);
    followingBloc =
        FollowingBloc(dataRepository, context.read<UsersBloc>(), widget.user.id!);
    fetchFollowers(false);
    fetchFollowing(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<FollowersBloc>(
              create: (_) => followersBloc,
            ),
            BlocProvider<FollowingBloc>(
              create: (_) => followingBloc,
            ),
          ],
          child: TabBarView(
            children: [
              FollowersScreen(
                followersBloc: followersBloc,
              ),
              FollowingScreen(
                followingBloc: followingBloc,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      bottom: TabBar(
        indicatorColor: AppColors.black,
        tabs: [_buildFirstTab(), _buildSecondTab()],
      ),
      title: _buildAppBarTitle(),
    );
  }

  Widget _buildFirstTab() {
    if (widget.user.id == loggedInUserBloc.loggedInUser!.id) {
      return Tab(
          icon: BlocBuilder<LoggedInUserBloc, LoggedInUserState>(
            bloc: loggedInUserBloc,
            builder: (context, state) {
              return Text(
                "${loggedInUserBloc.loggedInUser!.followersCount} ${AppStrings
                    .followers}",
                style: AppTextStyles.defaultTextStyleBold,
              );
            },
          ));
    } else {
      return Tab(
          icon: Text(
            "${widget.user.followersCount} ${AppStrings.followers}",
            style: AppTextStyles.defaultTextStyleBold,
          ));
    }
  }

  Widget _buildSecondTab() {
    if (widget.user.id == loggedInUserBloc.loggedInUser!.id) {
      return Tab(
          icon: BlocBuilder<LoggedInUserBloc, LoggedInUserState>(
            bloc: loggedInUserBloc,
            builder: (context, state) {
              return Text(
                "${loggedInUserBloc.loggedInUser!.followingCount} ${AppStrings
                    .following}",
                style: AppTextStyles.defaultTextStyleBold,
              );
            },
          ));
    } else {
      return Tab(
          icon: Text(
            "${widget.user.followingCount} ${AppStrings.following}",
            style: AppTextStyles.defaultTextStyleBold,
          ));
    }
  }

  Widget _buildAppBarTitle() {
    final title = widget.user.id == loggedInUserBloc.loggedInUser!.id
        ? loggedInUserBloc.loggedInUser!.userName!
        : widget.user.userName!;
    return Text(title,
        style: AppTextStyles.appBarTitleStyle);
  }

}
