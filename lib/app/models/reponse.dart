
import 'package:dronalms/app/models/tentativeTest.dart';

class Reponse {
  int id;
  String option;
  num score;
  bool isCorrect;

  int idQuestion;

  List<TentativeTest> tentatives;
  Reponse({this.id, this.option, this.score, this.isCorrect, this.idQuestion});

  factory Reponse.fromJson(Map<String, dynamic> json) {
    return Reponse(
        id: json['id'],
        option: json['option'],
        score: json['score'],
        isCorrect: json['isCorrect'],
        idQuestion: json['idQuestion']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'option': option,
        'score': score,
        'isCorrect': isCorrect,
        'idQuestion': idQuestion
      };
  @override
  String toString() {
    return 'Reponse{id: $id, option: $option, score: $score, isCorrect:$isCorrect, idReponse: $idQuestion}';
  }
}
