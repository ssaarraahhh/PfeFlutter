class MessageSignalR {
  String content;
  bool mine;

  MessageSignalR({this.content, this.mine});

  factory MessageSignalR.fromJson(Map<String, dynamic> json) {
    return MessageSignalR(
      content: json['content'],
      mine: json['mine'],
    );
  }
}
class User {
  int id;
  String name;
  String connId;
  List<MessageSignalR> msgs;

  User({
    this.id,
    this.name,
    this.connId,
    this.msgs,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      id: json['id'],
      name: json['name'],
      connId: json['connId'],

    );
  }
}
