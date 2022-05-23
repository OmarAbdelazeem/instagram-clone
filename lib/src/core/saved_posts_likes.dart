// class OfflineLikesRepository {
//   List<Map<String, dynamic>> _likedPostsIds = [];
//
//   void addPostIdToLikes({required String id, required int likes}) {
//     int index = _likedPostsIds.indexWhere((element) {
//       return element["id"] == id;
//     });
//     if (index > -1)
//       _likedPostsIds[index] = {"id": id, "likes": likes};
//     else {
//       _likedPostsIds.add({"id": id, "likes": likes});
//     }
//     print("_likedPostsIds length is ${_likedPostsIds.length}");
//   }
//
//   int getPostLikesCount(String postId) {
//     print("_likedPostsIds length is ${_likedPostsIds.length}");
//     final result = _likedPostsIds.where((element) {
//       print("element is ${element["id"]} and postId is ${postId}");
//       return element["id"] == postId;
//     });
//
//     if (result.isNotEmpty) {
//       return result.first["likes"];
//     } else
//       return -1;
//   }
//
//   void removePostIdFromLikes(String postId) {
//     _likedPostsIds.removeWhere((element) => element["id"] == postId);
//   }
// }

class OfflineLikesRepository {
  Map<String, Map<String, dynamic>> postsLikesInfo = {};

  void addPostLikesInfo(
      {required String id, required int likes, required bool isLiked}) {
    if (!postsLikesInfo.containsKey(id)) {
      postsLikesInfo.putIfAbsent(
          id, () => {"likes": likes, "isLiked": isLiked});
    } else {
      postsLikesInfo.update(
          id, (value) => {"likes": likes, "isLiked": isLiked});
    }
  }

  Map<String, dynamic> getPostLikesInfo(String postId) {
    print("postsLikesInfo.values is ${postsLikesInfo.values}");
    print("postsLikesInfo.length is ${postsLikesInfo.length}");
    // return postsLikesInfo[postId]!;
    return {};
  }

// void removePostIdFromLikes(String postId) {
//   _likedPostsIds.removeWhere((element) => element["id"] == postId);
// }
}
