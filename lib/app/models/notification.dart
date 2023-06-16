import 'package:StaffFlow/app/models/employe.dart';

class Notification1 {
  

   int id;
  String notifi;
  List<Employe> recivers;

  Notification1({ this.id,  this.notifi,  this.recivers});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notifi': notifi,
       'recivers': recivers.map((receiver) => receiver.toJson()).toList(),
    };
  }

  factory Notification1.fromJson(Map<String, dynamic> json) {
    List<dynamic> receiverList = json['recivers'] as List<dynamic>;
    List<Employe> parsedReceivers = receiverList.map((receiver) => Employe.fromJson(receiver)).toList();
    return Notification1(
      id: json['id'],
      notifi: json['notifi'],
      recivers: parsedReceivers,
    );
  }
}
