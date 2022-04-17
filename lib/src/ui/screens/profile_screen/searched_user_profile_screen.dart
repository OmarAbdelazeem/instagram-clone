import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/follow_bloc/follow_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_mentioned_posts_view.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_own_posts_view.dart';
import '../../common/app_tabs.dart';
import 'widgets/profile_details.dart';

class SearchedUserProfileScreen extends StatefulWidget {
  @override
  _SearchedUserProfileScreenState createState() =>
      _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {
  int selectedIndex = 0;
  UsersBloc? usersBloc;
  FollowBloc? followBloc;
  List<AppTabItemModel> tabsItems = [
    AppTabItemModel(
        selectedItem: Icon(
          Icons.grid_on,
          color: AppColors.black,
        ),
        unSelectedItem: Icon(
          Icons.grid_on,
          color: AppColors.grey,
        )),
    AppTabItemModel(
        selectedItem: Icon(
          Icons.person_outline,
          color: AppColors.black,
        ),
        unSelectedItem: Icon(
          Icons.person_outline,
          color: AppColors.grey,
        ))
  ];
  List<Widget>? _views;

  void onItemChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    usersBloc = context.read<UsersBloc>();
    followBloc = context.read<FollowBloc>();
    usersBloc!.add(ListenToSearchedUserStarted());
    context.read<FollowBloc>().add(CheckUserFollowingStarted(
        loggedInUser: usersBloc!.loggedInUser!,
        searchedUser: usersBloc!.searchedUser!.data));
    _views = [
      UserOwnPostsView(userId: usersBloc!.searchedUser!.data.id),
      UserMentionedPostsView(userId: usersBloc!.searchedUser!.data.id)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //Todo implement this function
      },
      child: BlocBuilder<FollowBloc, FollowState>(
          builder: (BuildContext _, state) {
        if (state is FollowLoading)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Column(
          children: <Widget>[
            _buildUpperDetails(state),
            Expanded(
                child: IndexedStack(children: _views!, index: selectedIndex)),
          ],
        );
      }),
    );
  }

  Widget _buildUpperDetails(FollowState state) {
    return Column(
      children: [
        BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
          return ProfileDetails(
              user: context.read<UsersBloc>().searchedUser!.data);
        }),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: _buildFollowButton(state),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _buildMessageButton(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        AppTabs(
          items: tabsItems,
          selectedIndex: selectedIndex,
          onItemChanged: onItemChanged,
        ),
      ],
    );
  }

  Widget _buildFollowButton(FollowState state) {
    return AppButton(
      height: 40,
      color: state is UserFollowed ? AppColors.white : AppColors.blue,
      titleStyle: TextStyle(
        color: state is UserFollowed ? AppColors.black : AppColors.white,
      ),
      title: state is UserFollowed ? AppStrings.following : AppStrings.follow,
      onTap: () {
        if (state is UserUnFollowed) {
          followBloc!.add(FollowEventStarted());
        } else {
          followBloc!.add(UnFollowEventStarted());
        }
      },
    );
  }

  Widget _buildMessageButton() {
    return AppButton(
      title: AppStrings.message,
      height: 40,
      color: AppColors.white,
      titleStyle: TextStyle(color: AppColors.black),
      onTap: () {},
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        usersBloc!.searchedUser!.data.userName,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
