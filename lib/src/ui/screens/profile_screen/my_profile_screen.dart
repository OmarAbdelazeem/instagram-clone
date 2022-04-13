import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_button.dart';
import 'package:instagramapp/src/ui/common/post_widget.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_mentioned_posts_view.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/views/user_own_posts_view.dart';
import 'package:provider/provider.dart';
import '../../../../router.dart';
import '../../../bloc/profile_bloc/profile_bloc.dart';
import '../../../bloc/users_bloc/users_bloc.dart';
import '../../common/app_tabs.dart';
import 'widgets/profile_details.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;
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
    final usersBloc = context.read<UsersBloc>();
    final user = usersBloc.loggedInUserDetails;
    usersBloc.add(ListenToUserDetailsStarted(user!.id));
    _views = [
      UserOwnPostsView(
          userId: user.id),
      UserMentionedPostsView(
          userId: user.id)
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
        // setProfileInfo();
      },
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
        BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
          print("UsersBloc state is $state");
          if (state is UserDetailsLoaded)
            return ProfileDetails(user: state.user);
          else
            return ProfileDetails(
                user: context.read<UsersBloc>().loggedInUserDetails!);
        }),
        SizedBox(
          height: 12,
        ),
        _buildEditProfileButton(),
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

  Padding _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: AppButton(
        onTap: () {
          NavigationUtils.pushNamed(
              route: AppRoutes.editProfileScreen, context: context);
        },
        borderColor: AppColors.grey.shade500,
        height: 35,
        title: AppStrings.editProfile,
        color: AppColors.white,
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        disabledColor: AppColors.scaffoldBackgroundColor,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        context.watch<UsersBloc>().loggedInUserDetails!.userName,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
