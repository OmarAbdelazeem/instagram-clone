import 'package:instagramapp/src/models/user_model/user_model.dart';

class SearchedUser {
  final bool isFollowing;
  final UserModel data;

  SearchedUser(this.data, this.isFollowing);
}