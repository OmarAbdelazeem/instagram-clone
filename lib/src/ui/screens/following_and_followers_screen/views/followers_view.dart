import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/ui/screens/following_and_followers_screen/widgets/follower_view.dart';

import '../../../../bloc/users_bloc/users_bloc.dart';

class FollowersScreen extends StatefulWidget {
  final UsersBloc usersBloc;

  const FollowersScreen({Key? key, required this.usersBloc}) : super(key: key);

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {

  @override
  void initState() {
    widget.usersBloc.add(FetchFollowersStarted());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _buildFollowers();
  }

  _buildFollowers() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (BuildContext context, state) {
       return ListView.builder(
         itemBuilder: (context, index) {
           return FollowerView(widget.usersBloc.followersUsers[index]);
         },
         itemCount: widget.usersBloc.followersUsers.length,
       );
      },
    );
  }

}
