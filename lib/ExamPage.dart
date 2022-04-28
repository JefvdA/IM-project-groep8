// ignore_for_file: file_names

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
              )
          ],
        ),
      ),
    );
  }
}
