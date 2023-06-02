import 'dart:async';

import 'package:dronalms/app/models/question.dart';
import 'package:dronalms/app/models/reponse.dart';
import 'package:dronalms/app/modules/AttendQuiz/views/timer.dart';
import 'package:dronalms/app/modules/CourseDetail/views/course_detail_view.dart';
import 'package:dronalms/app/routes/app_pages.dart';
import 'package:dronalms/app/services/api-reponse.dart';
import 'package:dronalms/app/services/api_question.dart';
import 'package:dronalms/app/theme/color_util.dart';
import 'package:dronalms/app/theme/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
  final int id;
  QuizScreen({Key key, this.id}) : super(key: key);
}

class _QuizScreenState extends State<QuizScreen> {
  // Define the datas
  Future<List<Question>> _questions;
  Future<List<Question>> _quess;
  int _secondsRemaining = 1 * 60; // 30 minutes

  Future<List<Reponse>> _reponses;
  Future<List<Reponse>> _reps;

  int currentQuestionIndex = 0;
  int score = 0;
  List<Reponse> selectedAnswers = [];

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

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
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
                TimerWidget(secondsRemaining: _secondsRemaining),
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
    bool isSelected = selectedAnswers.contains(resp);

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
            if (selectedAnswers.contains(resp)) {
              selectedAnswers.remove(resp);
            } else {
              selectedAnswers.add(resp);
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
        child: Text(isLastQuestion ? "Submit" : "Next"),
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
              selectedAnswers.clear();
            });
          }
        },
      ),
    );
  }

  _showScoreDialog() {
    return FutureBuilder<List<Question>>(
      future: _quess,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final questions = snapshot.data;
          return FutureBuilder<List<Reponse>>(
            future: _reponses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final responses = snapshot.data;
                final selectedQuestion = questions[currentQuestionIndex];
                final selectedResponses = responses
                    .where((response) =>
                        response.idQuestion == selectedQuestion.id)
                    .toList();
                final userSelectedResponses = selectedResponses
                    .where((response) => selectedAnswers.contains(response))
                    .toList();

                return AlertDialog(
                  title: Text(
                    "Quiz Results",
                    style: TextStyle(color: Colors.green),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("Answers:"),
                        SizedBox(height: 8),
                        DataTable(
                          columns: [
                            DataColumn(label: Text("Question")),
                            DataColumn(label: Text("Answer")),
                          ],
                          rows: responses
                              .map((response) {
                                final question = questions.firstWhere(
                                    (q) => q.id == response.idQuestion,
                                    orElse: () => null);
                                if (question == null) {
                                  return null;
                                }
                                final isSelected =
                                    userSelectedResponses.contains(response);
                                return DataRow(cells: [
                                  DataCell(Text(question.question)),
                                  DataCell(Text(
                                      "${response.option} ${isSelected ? "(Selected)" : ""}")),
                                ]);
                              })
                              .where((row) => row != null)
                              .toList(),
                        ),
                        SizedBox(height: 8),
                        Text("Your Choices:"),
                        SizedBox(height: 8),
                        DataTable(
                          columns: [
                            DataColumn(label: Text("Question")),
                            DataColumn(label: Text("Answer")),
                          ],
                          rows: userSelectedResponses
                              .map((response) {
                                final question = questions.firstWhere(
                                    (q) => q.id == response.idQuestion,
                                    orElse: () => null);
                                if (question == null) {
                                  return null;
                                }
                                return DataRow(cells: [
                                  DataCell(Text(question.question)),
                                  DataCell(Text(response.option)),
                                ]);
                              })
                              .where((row) => row != null)
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Restart"),
                      onPressed: () {
                        Navigator.pop(context);
                        // setState(() {
                        //   currentQuestionIndex = 0;
                        //   score = 0;
                        //   selectedAnswers.clear();

                        // });
                        Get.back();
                        Get.back();
                      
                      },
                    ),
                  ],
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
}
