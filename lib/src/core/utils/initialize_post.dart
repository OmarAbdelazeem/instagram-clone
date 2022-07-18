import 'package:instagramapp/src/core/utils/initialize_user.dart';

import '../../models/post_model/post_model.dart';
import '../../models/user_model/user_model.dart';
import '../../repository/data_repository.dart';

Future<PostModel> initializePost(Map<String, dynamic> data , DataRepository dataRepository) async {
  PostModel post = PostModel.fromJson(data);
  // get user data to add profile photo and username
  final userData = (await dataRepository.getUserDetails(post.publisherId))
      .data() as Map<String, dynamic>;
  UserModel user = await initializeUser(userData, dataRepository);
  post.owner = user;

  bool isLiked = await dataRepository.checkIfUserLikesPost(post.postId);
  post.isLiked = isLiked;
  return post;
}