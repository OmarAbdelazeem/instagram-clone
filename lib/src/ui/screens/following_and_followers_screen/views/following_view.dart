import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';

import '../../../../bloc/users_bloc/users_bloc.dart';
import '../widgets/follower_view.dart';

class FollowingScreen extends StatefulWidget {
  final UsersBloc usersBloc;

  const FollowingScreen({Key? key, required this.usersBloc}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  void initState() {
    widget.usersBloc.add(FetchFollowingStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFollowing();
  }

  _buildFollowing() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (BuildContext context, state) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return FollowerView(widget.usersBloc.followingUsers[index]);
          },
          itemCount: widget.usersBloc.followingUsers.length,
        );
      },
    );
  }
}
