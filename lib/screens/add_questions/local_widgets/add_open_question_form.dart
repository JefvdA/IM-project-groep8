import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddOpenQuestionForm extends StatefulWidget {
  final String exam;
  const AddOpenQuestionForm(this.exam, {Key? key}) : super(key: key);

  @override
  State<AddOpenQuestionForm> createState() => _AddOpenQuestionFormState();
}

class _AddOpenQuestionFormState extends State<AddOpenQuestionForm> {
  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        )
      ],
    );
  }

  void addQuestion() async {
    int id = await examsCollection
      .doc("exam")
      .collection('questions')
      .get()
      .then((value) {
      return value.docs.length + 1;
    });
    examsCollection.doc("exam").collection('questions').doc("question $id").set({
      "type": "OQ",
      "question": _questionController.text,
      "points": int.parse(_pointsController.text),
    });
    _questionController.clear();
    _pointsController.clear();
  }
}