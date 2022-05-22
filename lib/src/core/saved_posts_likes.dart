class SavedPostsLikes {
  static List<Map<String, dynamic>> _likedPostsIds = [];

  static void addPostIdToLikes({required String id, required int likes}) {
    int index = _likedPostsIds.indexWhere((element) {
      return element["id"] == id;
    });
    if (index > -1) _likedPostsIds.add({"id": id, "likes": likes});
  }

  static int getPostLikesCount(String postId) {
    int likes = -1;
    _likedPostsIds.where((element) {
      if (element["id"] == postId) {
        likes = element["likes"];
      }
      return element["id"] == postId;
    });
    return likes;
  }

  static void removePostIdFromLikes(String postId) {
    _likedPostsIds.removeWhere((element) => element["id"] == postId);
  }
}
