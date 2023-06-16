import 'User.Model.dart';

class ConvHist {
  int idFrom;
  int idTo;
  String msg;
  DateTime timeStamp;
  Users user ;


  ConvHist({
    this.idFrom,
    this.idTo,
    this.msg,
    this.timeStamp,
    this.user,   });

  factory ConvHist.fromJson(Map<String, dynamic> json) {
    return ConvHist(
      idFrom: json['idFrom'],
      idTo: json['idTo'],
      msg: json['msg'],
      timeStamp: DateTime.parse(json['timeStamp']),
      user: Users.fromJson(json['person']),

    );
  }
  Map<String, dynamic> toJson() => {
    'idFrom': idFrom,
    'idTo': idTo,
    'msg': msg,
    'timeStamp': timeStamp.toIso8601String(),
  'user': user?.toJson(),
         
   

  };
}
