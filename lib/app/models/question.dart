import 'package:dronalms/app/models/reponse.dart';

class Question {
  int id;
  String question;
  num score;
  int idTest;

  List<Reponse> reponses;

  Question({this.id, this.question, this.score, this.idTest});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'],
        question: json['question'],
        score: json['score'],
        idTest: json['idTest']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'question': question, 'score': score, 'idTest': idTest};
  @override
  String toString() {
    return 'Question{id: $id, question: $question, score: $score,  idTest: $idTest}';
  }
}
