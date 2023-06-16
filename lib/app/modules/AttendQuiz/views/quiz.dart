import 'dart:async';

import 'package:StaffFlow/app/components/button.dart';
import 'package:StaffFlow/app/models/question.dart';
import 'package:StaffFlow/app/models/reponse.dart';
import 'package:StaffFlow/app/modules/AttendQuiz/views/timer.dart';

import 'package:StaffFlow/app/services/api-reponse.dart';
import 'package:StaffFlow/app/services/api_question.dart';

import 'package:StaffFlow/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
  final int id;
  String temp;

  QuizScreen({Key key, this.id, this.temp}) : super(key: key);
}

class _QuizScreenState extends State<QuizScreen> {
  // Define the datas
  Future<List<Question>> _questions;
  Future<List<Question>> _quess;

  List<Set<Reponse>> selectedAnswers = [];

  Future<List<Reponse>> _reponses;
  Future<List<Reponse>> _reps;

  int currentQuestionIndex = 0;
  int score = 0;
  Map<int, List<Reponse>> selectedAnswersMap = {};

  @override
  void initState() {
    super.initState();
    _questions = ApiQuestion().fetchQuestion();
    _quess =
        _questions.then((t) => t.where((f) => f.idTest == widget.id).toList());
    _reponses = ApiReponse().fetchReponse();
    _startTimer();
  }

  Timer _timer;

  int remainingSeconds = 0;

  void _startTimer() {
  remainingSeconds = int.parse(widget.temp.substring(3, 5)) * 60 +
      int.parse(widget.temp.substring(0, 1)) * 60;
  
  const duration = Duration(seconds: 1);
  _timer = Timer.periodic(duration, (Timer timer) {
    setState(() {
      if (remainingSeconds > 0) {
        remainingSeconds--;
      } else {
        _timer.cancel();
        showDialog(context: context, builder: (_) => _showScoreDialog());
      }
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _questionWidget(),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  _questionWidget() {
    return Container(
      child: FutureBuilder<List<Question>>(
        future: _quess,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final questions = snapshot.data;
            final currentQuestion = questions[currentQuestionIndex];
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FutureBuilder<List<Reponse>>(
                  future: _reponses,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final responses = snapshot.data
                          .where((response) =>
                              response.idQuestion == currentQuestion.id)
                          .toList();
                      if (responses.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'No available answers for this question.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 242, 240, 237),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children:
                                responses.map((e) => _answerButton(e)).toList(),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Failed to load responses.'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                SizedBox(height: 16),
                TimerWidget(
                    secondsRemaining:
                       remainingSeconds),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load questions.'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _answerButton(Reponse resp) {
    int questionIndex = currentQuestionIndex;
    if (selectedAnswers.length <= questionIndex) {
      selectedAnswers.add({});
    }

    bool isSelected = selectedAnswers[questionIndex].contains(resp);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected ? Colors.orangeAccent : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedAnswers[questionIndex].remove(resp);
            } else {
              selectedAnswers[questionIndex].add(resp);
            }
          });
        },
        child: Text(resp.option),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    _quess.then((questions) {
      int l = questions.length;
      if (currentQuestionIndex == l - 1) {
        isLastQuestion = true;
      }
    }).catchError((error) {
      print("Error occurred while fetching responses: $error");
    });

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Suivant"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (isLastQuestion) {
            // Display score
            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            // Next question
            setState(() {
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }

  _showScoreDialog() {
    print(selectedAnswers);
    return FutureBuilder<List<Question>>(
      future: _quess,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final questions = snapshot.data;
          int score = 0;
          for (var answerSet in selectedAnswers) {
            for (var response in answerSet) {
              score = score + response.score;
              // Use the score as needed
            }
            if (score > 0) {
              score = score;
            } else {
              score = 0;
            }
          }

          return AlertDialog(
            title: Text(
              "Résultat",
              style: LmsTextUtil.textRoboto24(),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text("Vos Réponses :"),
                  SizedBox(height: 8),
                  for (var i = 0; i < questions.length; i++)
                    if (selectedAnswers.length > i)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(questions[i].question),
                          SizedBox(height: 1),
                          Container(
                            height: 100,
                            margin: EdgeInsets.only(
                                bottom:
                                    20), // Adjust the margin value to increase the space between rows
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(label: Text("")),
                                ],
                                headingRowHeight: 20,
                                columnSpacing: 20,
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            selectedAnswers[i].map((response) {
                                          final isCorrect = response.isCorrect;
                                          final color = isCorrect
                                              ? Colors.green
                                              : Colors.red;
                                          return Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .circle, // Replace with your desired icon
                                                color: color,
                                                size: 5,
                                              ),
                                              SizedBox(
                                                  width:
                                                      8), // Adjust the spacing between the icon and the text
                                              Text(
                                                response.option,
                                                style: TextStyle(color: color),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      )),
                                    ],
                                  ),
                                ],
                                dataRowHeight: 200,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                  Text("Score: $score"),
                ],
              ),
            ),
            actions: [
              MyButton(
                child: const Text("Recommencer"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestionIndex = 0;
                    selectedAnswers.clear();
                  });
                  Get.back();
                  Get.back();
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load questions.'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
