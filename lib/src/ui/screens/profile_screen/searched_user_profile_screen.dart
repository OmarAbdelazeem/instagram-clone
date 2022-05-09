import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/searched_user_bloc/searched_user_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/user_mentioned_posts_view.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_own_posts_view.dart';
import '../../common/app_tabs.dart';
import 'widgets/profile_details.dart';

class SearchedUserProfileScreen extends StatefulWidget {
  final String searchedUserId;

  SearchedUserProfileScreen(this.searchedUserId);

  @override
  _SearchedUserProfileScreenState createState() =>
      _SearchedUserProfileScreenState();
}

class _SearchedUserProfileScreenState extends State<SearchedUserProfileScreen> {
  int selectedIndex = 0;
  SearchedUserBloc? searchedUserBloc;
  LoggedInUserBloc? loggedInUserBloc;

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
    searchedUserBloc = context.read<SearchedUserBloc>();
    loggedInUserBloc = context.read<LoggedInUserBloc>();
    context
        .read<SearchedUserBloc>()
        .add(SetSearchedUserIdStarted(widget.searchedUserId));
    searchedUserBloc!.add(ListenToSearchedUserStarted());
    searchedUserBloc!.add(CheckIfUserIsFollowedStarted(
        loggedInUserId: loggedInUserBloc!.loggedInUser!.id!));

    _views = [
      UserOwnPostsView(userId: widget.searchedUserId),
      UserMentionedPostsView(userId: widget.searchedUserId)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent());
  }

  PreferredSize _buildAppBar() {
    final appBarHeight = AppBar().preferredSize.height;
    final appBarWidth = AppBar().preferredSize.width;
    return PreferredSize(
        preferredSize: Size(appBarWidth, appBarHeight),
        child: BlocBuilder<SearchedUserBloc, SearchedUserState>(
            builder: (BuildContext _, state) {
          bool condition = searchedUserBloc!.searchedUser != null &&
              searchedUserBloc!.isFollowed != null;

          return AppBar(
            title: Text(
              condition ? searchedUserBloc!.searchedUser!.userName! : "...",
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
        }));
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        //Todo implement this function
      },
      child: BlocBuilder<SearchedUserBloc, SearchedUserState>(
          builder: (BuildContext _, state) {
        if (searchedUserBloc!.searchedUser != null &&
            searchedUserBloc!.isFollowed != null) {
          return Column(
            children: <Widget>[
              _buildUpperDetails(state),
              Expanded(
                  child: IndexedStack(children: _views!, index: selectedIndex)),
            ],
          );
        } else if (state is SearchedUserLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchedUserError) {
          return Center(
            child: Text("${state.error}"),
          );
        }
        return Container();
      }),
    );
  }

  Widget _buildUpperDetails(SearchedUserState state) {
    return Column(
      children: [
        ProfileDetails(user: searchedUserBloc!.searchedUser!),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: _buildFollowButton(),
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

  Widget _buildFollowButton() {
    return AppButton(
      height: 40,
      color: context.read<SearchedUserBloc>().isFollowed
          ? AppColors.white
          : AppColors.blue,
      titleStyle: TextStyle(
        color: context.read<SearchedUserBloc>().isFollowed
            ? AppColors.black
            : AppColors.white,
      ),
      title: context.read<SearchedUserBloc>().isFollowed
          ? AppStrings.following
          : AppStrings.follow,
      onTap: () {
        if (context.read<SearchedUserBloc>().isFollowed) {
          searchedUserBloc!.add(
              UnFollowUserEventStarted(loggedInUserBloc!.loggedInUser!.id!));
        } else {
          searchedUserBloc!
              .add(FollowUserEventStarted(loggedInUserBloc!.loggedInUser!.id!));
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
}
