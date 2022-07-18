import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/searched_user_posts_view.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/widgets/searched_user_mentioned_posts.dart';
import '../../../bloc/posts_bloc/posts_bloc.dart';
import '../../common/app_tabs.dart';
import '../../common/profile_details.dart';

class SearchedUserProfileScreen extends StatefulWidget {
  UserModel user;

  SearchedUserProfileScreen({required this.user});

  @override
  _SearchedUserProfileScreenState createState() =>
      _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {
  int selectedIndex = 0;
  late SearchedUserBloc searchedUserBloc;

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

  Future<void> _fetchPosts(bool nextList) async {
    searchedUserBloc.add(FetchSearchedUserPostsStarted(nextList));
  }

  @override
  void initState() {
    setUpProfile();
    super.initState();
  }

  void setUpProfile() {
    searchedUserBloc = SearchedUserBloc(
      context.read<DataRepository>(),
      context.read<PostsBloc>(),
      widget.user.id!,
      context.read<UsersBloc>(),
    );

    searchedUserBloc.add(ListenToFollowUpdatesStarted());

    _views = [
      SearchedUserPostsView(),
      SearchedUserMentionedPostsView(userId: widget.user.id!)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchedUserBloc>(
      create: (_) => searchedUserBloc,
      child: Scaffold(appBar: _buildAppBar(), body: _buildContent()),
    );
  }

  PreferredSize _buildAppBar() {
    final appBarHeight = AppBar().preferredSize.height;
    final appBarWidth = AppBar().preferredSize.width;

    return PreferredSize(
        preferredSize: Size(appBarWidth, appBarHeight),
        child: AppBar(
          title: Text(
            widget.user.userName!,
            style: AppTextStyles.appBarTitleStyle,
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
        ));
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () => _fetchPosts(false),
      child: Column(
        children: <Widget>[
          _buildUpperDetails(),
          Expanded(
              child: IndexedStack(children: _views!, index: selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildUpperDetails() {
    return Column(
      children: [
        BlocBuilder<SearchedUserBloc, SearchedUserState>(
            builder: (context, state) {
          return ProfileDetails(user: widget.user);
        }),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(child: _buildFollowButton()),
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

  Widget _buildFollowButton() {
    return BlocConsumer<SearchedUserBloc, SearchedUserState>(
      listener: (context, state) {
        if (state is SearchedUserStateChanged) {
          widget.user = state.user;
        }
      },
      builder: (context, state) {
        return AppButton(
          height: 40,
          color: widget.user.isFollowed! ? AppColors.white : AppColors.blue,
          titleStyle: TextStyle(
            color: widget.user.isFollowed! ? AppColors.black : AppColors.white,
          ),
          title: widget.user.isFollowed!
              ? AppStrings.following
              : AppStrings.follow,
          onTap: () {
            if (widget.user.isFollowed!) {
              widget.user.isFollowed = false;
              widget.user.followersCount = widget.user.followersCount! - 1;
              searchedUserBloc.add(UnFollowUserEventStarted(widget.user));
            } else {
              widget.user.followersCount = widget.user.followersCount! + 1;
              widget.user.isFollowed = true;
              searchedUserBloc.add(FollowUserEventStarted(widget.user));
            }
          },
        );
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

  Widget _buildErrorView(String error) {
    return Center(
      child: Text("$error"),
    );
  }
}
