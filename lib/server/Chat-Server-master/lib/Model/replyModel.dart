class Reply {
  final int userId;
  final int messageId;
  final String avatar;
  final String userName;
  final String name;
  final String message;

  Reply(this.userId, this.messageId, this.avatar, this.userName, this.name,
      this.message);
  factory Reply.fromJson(var json) {
    return Reply(json['userId'], json['messageId'], json['avatar'],
        json['userName'], json['name'], json['message']);
  }
}
