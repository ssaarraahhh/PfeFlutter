import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int secondsRemaining;

  const TimerWidget({Key key, this.secondsRemaining}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
