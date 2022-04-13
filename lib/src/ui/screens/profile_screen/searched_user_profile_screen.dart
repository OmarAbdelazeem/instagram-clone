import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_mentioned_posts_view.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_own_posts_view.dart';
import '../../../bloc/profile_bloc/profile_bloc.dart';
import '../../common/app_tabs.dart';
import 'widgets/profile_details.dart';

class SearchedUserProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;

  SearchedUserProfileScreen({required this.userId, required this.userName});

  @override
  _SearchedUserProfileScreenState createState() =>
      _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {
  int selectedIndex = 0;
  UserModel? user;
  bool isFollowing = false;
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

  void onFollowButtonTapped() {
    setState(() {
      isFollowing = !isFollowing;
      if (isFollowing) {
        user!.followersCount++;
        // context.read<UsersBloc>().add(FollowEventStarted(
        //     senderId: context.read<ProfileBloc>().user!.id,
        //     receiverId: widget.userId));
        // final loggedInUser = context.read<UsersBloc>().loggedInUserDetails!;
        // loggedInUser.followingCount++;
        // context.read<ProfileBloc>().user = loggedInUser;
      } else {
        // user!.followersCount--;
        // context.read<UsersBloc>().add(UnFollowEventStarted(
        //     senderId: context.read<ProfileBloc>().user!.id,
        //     receiverId: widget.userId));
        // context.read<UsersBloc>().loggedInUserDetails!.followingCount--;
      }
    });
  }

  @override
  void initState() {
    final usersBloc = context.read<UsersBloc>();
    usersBloc.add(ListenToUserDetailsStarted(widget.userId));

    _views = [
      UserOwnPostsView(userId: widget.userId),
      UserMentionedPostsView(userId: widget.userId)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (BuildContext context, state) {
        if (state is SearchedUserLoaded) {
          setState(() {
            isFollowing = state.isFollowing;
          });
        }
      },
      builder: (BuildContext context, state) {
        if (state is UsersLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchedUserLoaded) {
          user = state.user;
          return RefreshIndicator(
            onRefresh: () async {
              //Todo implement this function
            },
            child: Column(
              children: <Widget>[
                _buildUpperDetails(),
                Expanded(
                    child:
                        IndexedStack(children: _views!, index: selectedIndex)),
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }

  Widget _buildUpperDetails() {
    return Column(
      children: [
        BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
          print("UsersBloc state is $state");
          if (state is UserDetailsLoaded)
            return ProfileDetails(user: state.user);
          else
            return ProfileDetails(
                user: context.read<UsersBloc>().searchedUserDetails!);
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
                child: _buildFollowButton(isFollowing),
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

  Widget _buildFollowButton(bool isFollowing) {
    return AppButton(
      height: 40,
      color: isFollowing ? AppColors.white : AppColors.blue,
      titleStyle: TextStyle(
        color: isFollowing ? AppColors.black : AppColors.white,
      ),
      title: isFollowing ? AppStrings.following : AppStrings.follow,
      onTap: onFollowButtonTapped,
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
        widget.userName,
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
