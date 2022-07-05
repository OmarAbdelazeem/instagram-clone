class PostUpdates {
  final int likes;
  final bool isLiked;

  PostUpdates(this.likes, this.isLiked,);

  factory PostUpdates.fromMap(Map<String, dynamic> map) {
    return PostUpdates(map["likes"], map["isLiked"]);
  }
}
