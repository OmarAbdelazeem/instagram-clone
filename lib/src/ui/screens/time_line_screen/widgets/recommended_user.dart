import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/my_profile_screen.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/searched_user_profile_screen.dart';

import '../../../../bloc/following_bloc/following_bloc.dart';
import '../../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../../../../bloc/posts_bloc/posts_bloc.dart';
import '../../../../bloc/searched_user_bloc/searched_user_bloc.dart';
import '../../../../models/user_model/user_model.dart';
import '../../../../repository/data_repository.dart';
import '../../../../repository/posts_repository.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';

class RecommendedUser extends StatefulWidget {
  final UserModel user;

  RecommendedUser(this.user);

  @override
  _RecommendedUserState createState() => _RecommendedUserState();
}

class _RecommendedUserState extends State<RecommendedUser> {
  late SearchedUserBloc searchedUserBloc;
  late UsersBloc usersBloc;

  @override
  void didChangeDependencies() {
    usersBloc = context.read<UsersBloc>();
    searchedUserBloc = SearchedUserBloc(
      context.read<DataRepository>(),
      context.read<PostsBloc>(),
      widget.user.id!,
      usersBloc,
    );
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => searchedUserBloc,
      child: GestureDetector(
        onTap: () {
          NavigationUtils.pushScreen(
              screen: SearchedUserProfileScreen(user: widget.user),
              context: context);
        },
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ProfilePhoto(
                  photoUrl: widget.user.photoUrl,
                  radius: 24,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.userName!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.user.bio!,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                _buildFollowButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    return AppButton(
      height: 40,
      color: widget.user.isFollowed! ? AppColors.white : AppColors.blue,
      titleStyle: TextStyle(
        color: widget.user.isFollowed! ? AppColors.black : AppColors.white,
      ),
      title: widget.user.isFollowed! ? AppStrings.following : AppStrings.follow,
      onTap: () {
        if (widget.user.isFollowed!) {
          searchedUserBloc.add(UnFollowUserEventStarted(widget.user));
        } else {
          searchedUserBloc.add(FollowUserEventStarted(widget.user));
        }
      },
    );
  }
}
