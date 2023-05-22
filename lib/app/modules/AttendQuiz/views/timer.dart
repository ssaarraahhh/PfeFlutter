import 'dart:async';

import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerComplete;

  const QuizTimer({
    Key key,
     this.duration,
     this.onTimerComplete,
  }) : super(key: key);

  @override
  _QuizTimerState createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
   Timer _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          widget.onTimerComplete();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time Left: $_remainingTime',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
