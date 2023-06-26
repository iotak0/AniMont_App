class ChatModel {
  String name;
  String userName;
  String avatar;
  bool isGroup;
  String time;
  String currentMessage;
  String status;
  bool select = false;
  int id;
  ChatModel({
    required this.name,
    required this.userName,
    required this.avatar,
    required this.isGroup,
    required this.time,
    required this.currentMessage,
    required this.status,
    this.select = false,
    required this.id,
  });
}
