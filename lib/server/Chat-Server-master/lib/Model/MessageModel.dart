import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/replyModel.dart';

class MessageModel {
  final int id;
  final int userId;
  final String userName;
  final String name;
  final String message;
  final String avatar;
  final bool admin;
  final reply;
  final String time;

  MessageModel(this.id, this.userId, this.userName, this.name, this.message,
      this.avatar, this.admin, this.reply,this.time);
}
