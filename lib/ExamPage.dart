// ignore_for_file: file_names
import 'dart:async';
import 'package:examap/test.dart';
import 'package:flutter/material.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  String user = LoggedIn.sNummer;
  List<String> question = [
    "Wat is het beste framework ?",
    "Wat is de mooiste kleur ?",
    "Leg uit waarom dit de mooiste kleur is ?"
  ];
  //timer
  static const countdownDuration = Duration(hours: 3);
  Duration _duration = Duration();
  Timer? timer;

  bool isCountdown = true;

  @override
  void initState() {
    super.initState();

    startTimer();
    reset();
  }

  void reset() {
    if (isCountdown) {
      setState(() => _duration = countdownDuration);
    } else {
      setState(() => _duration = Duration());
    }
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = _duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user),
            for (var i in question)
              Column(
                children: [Text(i)],
              ),
            buildTime()
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours),
        const SizedBox(width: 5),
        buildTimeCard(time: minutes),
        const SizedBox(width: 5),
        buildTimeCard(time: seconds),
      ],
    );
  }

  Widget buildTimeCard({required String time}) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
}
