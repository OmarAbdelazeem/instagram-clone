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
  UserModel user = UserModel(
      photoUrl:
          "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg",
      userName: "Omar Abdelazeem",
      bio: "this is a bio",
      id: "123",
      email: "omar@email.com",
      postsCount: 1,
      followersCount: 3,
      followingCount: 5,
      timestamp: (Timestamp.now()).toDate());


  @override
  void initState() {
    widget.usersBloc.add(event)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
        bloc: widget.usersBloc,
        builder: (context, state) {
          return Column(
            children: [
              FollowerView(user),
              FollowerView(user),
              FollowerView(user),
            ],
          );
        });
  }
}
