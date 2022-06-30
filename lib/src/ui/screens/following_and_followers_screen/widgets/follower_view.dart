import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/my_profile_screen.dart';
import 'package:instagramapp/src/ui/screens/profile_screen/searched_user_profile_screen.dart';

import '../../../../bloc/following_bloc/following_bloc.dart';
import '../../../../bloc/likes_bloc/likes_bloc.dart';
import '../../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../../../../bloc/searched_user_bloc/searched_user_bloc.dart';
import '../../../../models/user_model/user_model.dart';
import '../../../../repository/data_repository.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_strings.dart';
import '../../../common/app_button.dart';

class FollowerView extends StatefulWidget {
  final UserModel user;

  FollowerView(this.user);

  @override
  _FollowerViewState createState() => _FollowerViewState();
}

class _FollowerViewState extends State<FollowerView> {
  late SearchedUserBloc searchedUserBloc;
  late FollowingBloc followingBloc;

  @override
  void didChangeDependencies() {
    followingBloc = context.read<FollowingBloc>();
    searchedUserBloc = SearchedUserBloc(
        dataRepository: context.read<DataRepository>(),
        likesBloc: context.read<LikesBloc>(),
        searchedUserId: widget.user.id!,
        followingBloc: followingBloc);
    searchedUserBloc.setFollowInitialValue(true);
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
              screen:
                  SearchedUserProfileScreen(searchedUserId: widget.user.id!),
              context: context);
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildUserView(),
              SizedBox(
                height: 5,
              ),
              _buildFollowButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfilePhoto(
          photoUrl: widget.user.photoUrl,
          radius: 24,
        ),
        SizedBox(
          width: 15,
        ),
        _buildUserDetails()
      ],
    );
  }

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
      ],
    );
  }

  Widget _buildFollowButton() {
    return BlocProvider<SearchedUserBloc>(
      create: (_) => searchedUserBloc,
      child: BlocBuilder<SearchedUserBloc, SearchedUserState>(
        builder: (context, state) {
          return AppButton(
            height: 40,
            color:
            searchedUserBloc.isFollowed ? AppColors.white : AppColors.blue,
            titleStyle: TextStyle(
              color: searchedUserBloc.isFollowed
                  ? AppColors.black
                  : AppColors.white,
            ),
            title: searchedUserBloc.isFollowed
                ? AppStrings.following
                : AppStrings.follow,
            onTap: () {
              if (searchedUserBloc.isFollowed) {
                searchedUserBloc.add(UnFollowUserEventStarted());
              } else {
                searchedUserBloc.add(FollowUserEventStarted());
              }
            },
          );
        },
      ),
    );
  }

  // Widget _buildFollowButton() {
  //   return AppButton(
  //     height: 40,
  //     color: searchedUserBloc.isFollowed ? AppColors.white : AppColors.blue,
  //     titleStyle: TextStyle(
  //       color: searchedUserBloc.isFollowed ? AppColors.black : AppColors.white,
  //     ),
  //     title: searchedUserBloc.isFollowed
  //         ? AppStrings.following
  //         : AppStrings.follow,
  //     onTap: () {
  //       if (searchedUserBloc.isFollowed) {
  //         searchedUserBloc.add(UnFollowUserEventStarted());
  //       } else {
  //         searchedUserBloc.add(FollowUserEventStarted());
  //       }
  //     },
  //   );
  // }

  // Widget _buildFollowButton() {
  //   return BlocBuilder<FollowingBloc, FollowingState>(
  //       builder: (context, state) {
  //     bool isFollowing = followingBloc.getFollowerId(widget.user.id!) != null;
  //     return AppButton(
  //       height: 40,
  //       color: isFollowing ? AppColors.white : AppColors.blue,
  //       titleStyle: TextStyle(
  //         color: isFollowing ? AppColors.black : AppColors.white,
  //       ),
  //       title: isFollowing ? AppStrings.following : AppStrings.follow,
  //       onTap: () {
  //         if (isFollowing) {
  //           searchedUserBloc.add(UnFollowUserEventStarted());
  //         } else {
  //           searchedUserBloc.add(FollowUserEventStarted());
  //         }
  //       },
  //     );
  //   });
  // }
}
