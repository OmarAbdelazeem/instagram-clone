import 'package:flutter/material.dart';

import '../../../../bloc/users_bloc/users_bloc.dart';

class FollowingScreen extends StatefulWidget {
  final UsersBloc usersBloc;

  const FollowingScreen({Key? key, required this.usersBloc}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
