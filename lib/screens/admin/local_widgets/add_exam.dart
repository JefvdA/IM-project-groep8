// ignore_for_file: file_names

import 'package:examap/screens/exam/code_correction_add_screen.dart';
import 'package:examap/screens/exam/multiple_choice_add_screen.dart';
import 'package:examap/screens/exam/open_question_add_screen.dart';
import 'package:flutter/material.dart';

class AddExam extends StatefulWidget {
  const AddExam({Key? key}) : super(key: key);

  @override
  State<AddExam> createState() => _AddExamQuestions();
}

class _AddExamQuestions extends State<AddExam> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          heightFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OQExam()),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text(
                  "OPEN VRAAG",
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MCExam()),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text("MULTIPLE CHOICE",
                    style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CCExam()),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text("CODE CORRECTIE",
                    style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
