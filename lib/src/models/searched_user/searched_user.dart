import 'package:instagramapp/src/models/user_model/user_model.dart';

class SearchedUser {
  final bool isFollowing;
  final UserModel user;

  SearchedUser(this.user, this.isFollowing);
}