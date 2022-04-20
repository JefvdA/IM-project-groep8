import 'package:examap/test.dart';
import 'package:flutter/material.dart';

class Exam extends StatefulWidget {
  const Exam({Key? key}) : super(key: key);

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  String user = LoggedIn.sNummer;
  List<String> Questions = [
    "Wat is het beste framework ?",
    "Wat is de mooiste kleur ?",
    "Leg uit waarom dit de mooiste kleur is ?"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user),
            for (var i in Questions)
              Column(
                children: [Text(i)],
              )
          ],
        ),
      ),
    );
  }
}
