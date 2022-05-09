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
      body: Container(
        child: Column(
          children: [
            DropdownButton(
                value: _selectedValue,
                items: Items,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value!;
                    print("werkt");
                  });
                }),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Vraag',
              ),
            ),
            if (_selectedValue == "Open vraag")
              TextField(
                controller: _rightAnswerController,
                decoration: const InputDecoration(
                  labelText: 'Antwoord',
                ),
              ),
            if (_selectedValue == "Multiple choice")
              Column(children: [
                TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Antwoorden Opties gesplits door kommas',
                  ),
                ),
                TextField(
                  controller: _rightAnswerController,
                  decoration: const InputDecoration(
                    labelText: 'Juiste Antwoord',
                  ),
                )
              ]),
            ElevatedButton(
                onPressed: () {
                  editQuestion();
                  Navigator.pop(context);
                },
                child: const Text('Toevoegen')),
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
