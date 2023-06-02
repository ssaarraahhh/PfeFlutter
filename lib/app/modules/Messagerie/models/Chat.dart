class ChatModel {
  int idFrom;
  int idTo;
  String msg;
  DateTime timeStamp;


  ChatModel({
     this.idFrom,
     this.idTo,
     this.msg,
     this.timeStamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      idFrom: json['idFrom'],
      idTo: json['idTo'],
      msg: json['msg'],
      timeStamp: DateTime.parse(json['timeStamp']),
    );
  }
  Map<String, dynamic> toJson() => {
    'idFrom': idFrom,
    'idTo': idTo,
    'msg': msg,
    'timeStamp': timeStamp.toIso8601String(),
  };
}
