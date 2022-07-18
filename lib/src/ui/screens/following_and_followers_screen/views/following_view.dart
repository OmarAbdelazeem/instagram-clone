import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/following_bloc/following_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';

import '../../../../bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import '../widgets/follower_view.dart';

class FollowingScreen extends StatefulWidget {
  final FollowingBloc followingBloc;

  const FollowingScreen({Key? key, required this.followingBloc})
      : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  late LoggedInUserBloc loggedInUserBloc;
  late ScrollController scrollController;

  Future<void> fetchFollowing(bool nextList) async {
    widget.followingBloc.add(FetchFollowingUsersStarted(
        nextList));
  }

  void _scrollListener() {
    bool nextFollowingLoading =
        widget.followingBloc.state is FollowingNextLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!nextFollowingLoading &&
          !widget.followingBloc.isFollowingReachedToTheEnd) {
        fetchFollowing(true);
      }
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => fetchFollowing(false),
        child: BlocBuilder<FollowingBloc, FollowingState>(
          builder: (BuildContext context, state) {
            if (state is FollowingFirstLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FollowingError) {
              return _buildErrorView(state.error);
            } else {
              return _buildFollowing(state);
            }
          },
        ));
  }

  Widget _buildFollowing(FollowingState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              return FollowerView(widget.followingBloc.followingUsers[index]);
            },
            itemCount: widget.followingBloc.followingUsers.length,
          ),
        ),
        SizedBox(height: 12),
        state is FollowingNextLoading
            ? CircularProgressIndicator()
            : Container()
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Text(error);
  }
}
