import 'package:flutter/cupertino.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/services/profile_service.dart';


class Data {
  static UserModel defaultUser;
  static UserModel currentUser;
  static Post currentPost;

  static Future updateDefaultUser() async{
    ProfileService _profileService = ProfileService();
    Data.defaultUser = await _profileService.getProfileMainInfo(id: Data.defaultUser.id);
  }

  static void changeCurrentUser(UserModel user){
    currentUser = user;
  }
  static void changeCurrentPost(Post post){
    currentPost = post;
  }

}