import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCodeCorrectionForm extends StatefulWidget {
  final String examId;
  final String questionId;
  final LinkedHashMap<String, dynamic> question;
  const EditCodeCorrectionForm(this.examId, this.questionId, this.question, {Key? key}) : super(key: key);

  @override
  State<EditCodeCorrectionForm> createState() => _EditCodeCorrectionFormState();
}

class _EditCodeCorrectionFormState extends State<EditCodeCorrectionForm> {
  final CollectionReference examsCollection =
    FirebaseFirestore.instance.collection('exams');

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _givenCodeController = TextEditingController();
  final TextEditingController _correctCodeController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  bool _isCaseSensitive = false;

  loadQuestionData() {
    _questionController.text = widget.question['question'];
    _givenCodeController.text = widget.question['given_code'];
    _correctCodeController.text = widget.question['correct_code'];
    _pointsController.text = widget.question['points'].toString();
    _isCaseSensitive = widget.question['case_sensitive'];
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
          height: 200,
          child: TextField(
            maxLines: 10,
            controller: _givenCodeController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Start-code',
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
          height: 200,
          child: TextField(
            maxLines: 10,
            controller: _correctCodeController,
            decoration: const InputDecoration(
              label: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      child: Text(
                        'Correcte Code',
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
          width: 600,
          height: 80,
          child: Row(
            children: [
              const Text(
                'Case-sensitive:'
              ),
              Switch(
                value: _isCaseSensitive,
                onChanged: ((value) => setState(() => _isCaseSensitive = value)),
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
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
      ],
    );
  }
  
  void addQuestion() async {
    String id = widget.questionId;
    examsCollection.doc(widget.examId).collection('questions').doc(id).set({
      "type": "CC",
      "question": _questionController.text,
      "given_code": _givenCodeController.text,
      "correct_code": _correctCodeController.text,
      "case_sensitive": _isCaseSensitive,
      "points": int.parse(_pointsController.text),
    });
    Navigator.pop(context);
  }
}