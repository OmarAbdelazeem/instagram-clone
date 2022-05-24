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

  Map<String, dynamic>? getPostLikesInfo(String postId) {
    return postsLikesInfo[postId];
  }

}
