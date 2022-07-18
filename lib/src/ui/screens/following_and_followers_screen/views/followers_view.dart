import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/followers_bloc/followers_bloc.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/widgets/follower_view.dart';

class FollowersScreen extends StatefulWidget {
  final FollowersBloc followersBloc;

  const FollowersScreen({Key? key, required this.followersBloc})
      : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  late LoggedInUserBloc loggedInUserBloc;
  late ScrollController scrollController;

  Future<void> fetchFollowers(bool nextList) async {
    widget.followersBloc.add(FetchFollowersStarted(nextList));
  }

  void _scrollListener() {
    bool nextFollowersLoading =
        widget.followersBloc.state is FollowersNextLoading;
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!nextFollowersLoading &&
          !widget.followersBloc.isFollowersReachedToTheEnd) {
        fetchFollowers(true);
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
        onRefresh: () => fetchFollowers(false),
        child: BlocBuilder<FollowersBloc, FollowersState>(
          builder: (BuildContext context, state) {
            if (state is FollowersFirstLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FollowersError) {
              return _buildErrorView(state.error);
            } else {
              return _buildFollowers(state);
            }
          },
        ));
  }

  Widget _buildFollowers(FollowersState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              return FollowerView(widget.followersBloc.followersUsers[index]);
            },
            itemCount: widget.followersBloc.followersUsers.length,
          ),
        ),
        SizedBox(height: 12),
        state is FollowersNextLoading
            ? CircularProgressIndicator()
            : Container()
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Text(error);
  }
}
