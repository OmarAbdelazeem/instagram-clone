
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

  Stream<Map<String, dynamic>?> listenToLikesInfo(
      String postId) async* {
    yield postsLikesInfo[postId];
    // yield getPostLikesInfo(postId);
    // var likesInfo = getPostLikesInfo(postId);
    // if (likesCount != likesInfo!["likes"]) yield likesInfo;
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }
}
