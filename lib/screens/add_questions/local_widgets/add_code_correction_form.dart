import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCodeCorrectionForm extends StatefulWidget {
  final String exam;
  const AddCodeCorrectionForm(this.exam, {Key? key}) : super(key: key);

  @override
  State<AddCodeCorrectionForm> createState() => _AddCodeCorrectionFormState();
}

class _AddCodeCorrectionFormState extends State<AddCodeCorrectionForm> {
  final CollectionReference examsCollection =
    FirebaseFirestore.instance.collection('exams');

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _givenCodeController = TextEditingController();
  final TextEditingController _correctCodeController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  bool _isCaseSensitive = false;

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
    int id = await examsCollection
      .doc(widget.exam)
      .collection('questions')
      .get()
      .then((value) {
      return value.docs.length + 1;
    });
    examsCollection.doc(widget.exam).collection('questions').doc("question $id").set({
      "type": "CC",
      "question": _questionController.text,
      "given_code": _givenCodeController.text,
      "correct_code": _correctCodeController.text,
      "case_sensitive": _isCaseSensitive,
      "points": int.parse(_pointsController.text),
    });
    _questionController.clear();
    _givenCodeController.clear();
    _correctCodeController.clear();
    _pointsController.clear();
  }
}