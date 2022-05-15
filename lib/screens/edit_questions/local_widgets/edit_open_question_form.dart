import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditOpenQuestionForm extends StatefulWidget {
  final String examId;
  final String questionId;
  final LinkedHashMap<String, dynamic> question;
  const EditOpenQuestionForm(this.examId, this.questionId, this.question, {Key? key}) : super(key: key);

  @override
  State<EditOpenQuestionForm> createState() => _EditOpenQuestionFormState();
}

class _EditOpenQuestionFormState extends State<EditOpenQuestionForm> {
  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  void loadQuestionData() {
    _questionController.text = widget.question['question'];
    _pointsController.text = widget.question['points'].toString();
  }

  @override
  Widget build(BuildContext context) {
    loadQuestionData();
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          width: 600,
          height: 80,
          child: TextField(
            controller: _questionController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Vraag',
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 600,
          height: 80,
          child: TextField(
            controller: _pointsController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Aantal punten',
                      ),
                    ),
                    WidgetSpan(
                      child: Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 400,
          height: 30,
          child: ElevatedButton.icon(
            onPressed: () {
              addQuestion();
            },
            icon: const Icon(
              Icons.save_alt_rounded,
              size: 30,
            ),
            label:
                const Text("VRAAG OPSLAAN", style: TextStyle(fontSize: 24)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          width: 400,
          height: 30,
          child: ElevatedButton.icon(
            onPressed: () {
              removeQuestion();
            },
            icon: const Icon(
              Icons.delete_rounded,
              size: 30,
            ),
            label:
                const Text("VRAAG VERWIJDEREN", style: TextStyle(fontSize: 24)),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
          ),
        )
      ],
    );
  }

  void addQuestion() {
    String id = widget.questionId;
    examsCollection.doc(widget.examId).collection('questions').doc(id).set({
      "type": "OQ",
      "question": _questionController.text,
      "points": int.parse(_pointsController.text),
    });
    Navigator.pop(context);
  }

  void removeQuestion() {
    examsCollection.doc(widget.examId).collection('questions').doc(widget.questionId).delete();
    Navigator.pop(context);
  }
}