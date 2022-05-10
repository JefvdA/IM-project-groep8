import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/admin/local_widgets/add_questions_tab.dart';
import 'package:flutter/material.dart';

class EditQuestionsTab extends StatefulWidget {
  final data;
  final exam;
  const EditQuestionsTab(this.data, this.exam, {Key? key}) : super(key: key);

  @override
  State<EditQuestionsTab> createState() => _EditQuestionsTabState(data, exam);
}

class _EditQuestionsTabState extends State<EditQuestionsTab> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  TextEditingController _rightAnswerController = TextEditingController();
  int id = 0;
  String _selectedValue = "Open vraag";
  CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');
  String exam = "";
  _EditQuestionsTabState(data, exam) {
    data = data + 1;
    this.id = data;
    this.exam = exam;
  }
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> Items = [
      const DropdownMenuItem(
        child: Text("Open vraag"),
        value: "Open vraag",
      ),
      const DropdownMenuItem(
        child: Text("Multiple choice"),
        value: "Multiple choice",
      ),
      const DropdownMenuItem(
        child: Text("Code correction"),
        value: "Code correction",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamAP'),
      ),
      body: Container(
        child: Column(
          children: [
            DropdownButton(
                value: _selectedValue,
                items: Items,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                }),
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
            if (_selectedValue == "Code correction")
              Container(
                margin: const EdgeInsets.all(8),
                width: 600,
                height: 80,
                child: TextField(
                  controller: _rightAnswerController,
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
            if (_selectedValue == "Multiple choice")
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    width: 600,
                    height: 80,
                    child: TextField(
                      controller: _answerController,
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
                      controller: _rightAnswerController,
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
                ],
              ),
            Container(
              margin: const EdgeInsets.all(8),
              width: 400,
              height: 30,
              child: ElevatedButton.icon(
                onPressed: () {},
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
        ),
      ),
    );
  }

  editQuestion() {
    if (_selectedValue == "Open vraag") {
      examsCollection.doc(exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
        "antwoord": _rightAnswerController.text
      });
    } else if (_selectedValue == "Multiple choice") {
      examsCollection.doc(exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
        "antwoord": _rightAnswerController.text,
        "opties": _answerController.text.split(",")
      });
    } else if (_selectedValue == "Code correction") {
      examsCollection.doc(exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
      });
    }
  }
}
