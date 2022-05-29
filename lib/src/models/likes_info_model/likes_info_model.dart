class LikesInfo {
  final int likes;
  final bool isLiked;

  LikesInfo(this.likes, this.isLiked);

  factory LikesInfo.fromMap(Map<String, dynamic> map) {
    return LikesInfo(map["likes"], map["isLiked"]);
  }
}
