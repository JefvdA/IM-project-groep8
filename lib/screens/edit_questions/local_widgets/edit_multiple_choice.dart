import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditMultipleChoiceForm extends StatefulWidget {
  final String examId;
  final String questionId;
  final LinkedHashMap<String, dynamic> question;
  const EditMultipleChoiceForm(this.examId, this.questionId, this.question, {Key? key}) : super(key: key);

  @override
  State<EditMultipleChoiceForm> createState() => _EditMultipleChoiceFormState();
}

class _EditMultipleChoiceFormState extends State<EditMultipleChoiceForm> {
  final CollectionReference examsCollection =
    FirebaseFirestore.instance.collection('exams');

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();
  final TextEditingController _correctOptionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  void loadQuestionData() {
    _questionController.text = widget.question['question'];
    _optionsController.text = widget.question['options'].toString().substring(1, widget.question['options'].toString().length - 1);
    _correctOptionController.text = widget.question['correct_option'];
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
            controller: _optionsController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Antwoorden  gescheiden zijn door ,',
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
            controller: _correctOptionController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Oplossing',
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
      "type": "MC",
      "question": _questionController.text,
      "options": _optionsController.text.split(","),
      "correct_option": _correctOptionController.text,
      "points": int.parse(_pointsController.text),
    });
    Navigator.pop(context);
  }
  
  void removeQuestion() {}
}