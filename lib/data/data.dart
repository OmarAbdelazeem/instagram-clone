import 'package:flutter/cupertino.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/services/profile_service.dart';


class Data {
  static User defaultUser;
  static User currentUser;
  static Post currentPost;

  static Future updateDefaultUser() async{
    ProfileService _profileService = ProfileService();
    Data.defaultUser = await _profileService.getProfileMainInfo(id: Data.defaultUser.id);
  }

  static void changeCurrentUser(User user){
    currentUser = user;
  }
  static void changeCurrentPost(Post post){
    currentPost = post;
  }

}