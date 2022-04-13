import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/users_bloc/users_bloc.dart';
import 'package:instagramapp/src/ui/common/profile_photo.dart';

import '../../../../core/utils/navigation_utils.dart';
import '../../../../models/user_model/user_model.dart';
import '../../profile_screen/searched_user_profile_screen.dart';

class SearchResult extends StatelessWidget {
  final UserModel user;

  SearchResult(this.user);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<UsersBloc>().add(SetSearchedUserStarted(user));
        NavigationUtils.pushScreen(
            screen: SearchedUserProfileScreen(), context: context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePhoto(photoUrl: user.photoUrl, radius: 22),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.userName,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
