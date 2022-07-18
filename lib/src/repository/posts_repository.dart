// import 'package:instagramapp/src/models/post_model/post_model_response/post_model_response.dart';
//
// import '../models/post_model/post_model_request/post_model_request.dart';
//
// class PostsRepository {
//   List<PostModel> posts = [];
//
//   void addPost(PostModel post) {
//     int index = posts.indexWhere((element) => element.postId == post.postId);
//     if (index > -1) {
//       posts[index] = post;
//     } else {
//       posts.add(post);
//     }
//   }
//
//   PostModel ? getPost(String postId) {
//     return posts.firstWhere((element) => element.postId == postId);
//   }
// }
