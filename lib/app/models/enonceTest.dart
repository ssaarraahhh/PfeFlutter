import 'package:dronalms/app/models/question.dart';

class EnonceTest {
  int id;
  String temps;
  num note;
  int idFormation;

  List<Question> questions;

  EnonceTest(
      {this.id, this.temps, this.note, this.idFormation, this.questions});

  factory EnonceTest.fromJson(Map<String, dynamic> json) {
    return EnonceTest(
        id: json['id'],
        temps: json['temps'],
        note: json['note'],
        idFormation: json['idFormation']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'temps': temps, 'note': note, 'idFormation': idFormation};
  @override
  String toString() {
    return 'Enoncé{id: $id, temps: $temps, note: $note,  idFormation: $idFormation}';
  }
}
