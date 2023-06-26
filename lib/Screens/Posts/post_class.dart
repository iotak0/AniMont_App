class Post {
  final String id;
  final Map<String, dynamic> user;
  bool isLiked;
  bool admin = false;
  final String userId;
  final String caption;
  final String postTime;
  bool delete = false;
  bool isFollowed;
  final String likedBy = "iotak0";
  final List<Map<String, dynamic>> postCont;
  int commentsCount;
  int likes;
  final String postContId;
  final String date;

  Post(
    this.id,
    //this.username,
    this.userId,
    this.user,
    this.caption,
    this.postTime,
    //this.likedBy,
    this.postCont,
    this.isLiked,
    this.commentsCount,
    this.likes,
    this.postContId,
    this.date,
    this.isFollowed,
    this.admin,
  );
  static Post fromJson(json) => Post(
      json['id'] ?? '',
      json['post_user'] ?? '',
      json['user'] ?? '',
      json['post_date'] ?? '',
      json['caption'] ?? '',
      json['posts_cont']["post_content"] ?? [],
      json['is_like'] ?? false,
      json['comments'] ?? 0,
      json['likes'] ?? 0,
      json['post_cont'] ?? 0,
      json['post_data'],
      json['is_followed'],
      json['admin']);
}
