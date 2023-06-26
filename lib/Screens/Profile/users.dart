class Users {
  final String name;
  final String username;
  final String avatar;
  final int id;

  Users(this.id, this.name, this.username, this.avatar);
  static Users fromJson(json) => Users(int.parse(json['id']),
      json['name'].toString(), json['username'], json['avatar']);
}
