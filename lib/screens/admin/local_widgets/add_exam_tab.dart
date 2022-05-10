// ignore_for_file: file_names

import 'package:examap/screens/add_exam_questions/add_ccquestion_screen.dart';
import 'package:examap/screens/add_exam_questions/add_mcquestion_screen.dart';
import 'package:examap/screens/add_exam_questions/add_oquestion_screen.dart';
import 'package:examap/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExamTab extends StatefulWidget {
  const AddExamTab({Key? key}) : super(key: key);

  @override
  State<AddExamTab> createState() => _AddExamTabState();
}

class _AddExamTabState extends State<AddExamTab> {
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
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: const Text(
                  "Sign out",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddOQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
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
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddMCQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
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
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddCCQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
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
