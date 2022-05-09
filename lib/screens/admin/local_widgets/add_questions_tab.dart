import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/admin/local_widgets/edit_questions_tab.dart';
import 'package:flutter/material.dart';

class AddQuestionsTab extends StatefulWidget {
  final String exam;
  const AddQuestionsTab(this.exam, {Key? key}) : super(key: key);

  @override
  State<AddQuestionsTab> createState() => _AddQuestionsTabState(exam);
}

class _AddQuestionsTabState extends State<AddQuestionsTab> {
  _AddQuestionsTabState(this.exam);
  CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _rightAnswerController = TextEditingController();
  int id = 0;

  String exam = "";
  String _selectedValue = "Open vraag";

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
                  });
                }),
            StreamBuilder(
              stream: examsCollection
                  .doc(this.exam)
                  .collection('vragen')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title:
                              Text(snapshot.data.docs[index].data()['vraag']),
                          onTap: () {
                            print(exam);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditQuestionsTab(index, exam),
                              ),
                            );
                          });
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
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
                onPressed: addQuestion, child: const Text('Toevoegen')),
          ],
        ),
      ),
    );
  }

  void addQuestion() async {
    int id = await examsCollection
        .doc(this.exam)
        .collection('vragen')
        .get()
        .then((value) {
      return value.docs.length + 1;
    });
    print(id);
    if (_selectedValue == "Open vraag") {
      examsCollection.doc(this.exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
        "antwoord": _rightAnswerController.text
      });
    } else if (_selectedValue == "Multiple choice") {
      examsCollection.doc(this.exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
        "antwoord": _rightAnswerController.text,
        "opties": _answerController.text.split(",")
      });
    } else if (_selectedValue == "Code correction") {
      examsCollection.doc(this.exam).collection('vragen').doc("vraag $id").set({
        "type": _selectedValue,
        "vraag": _questionController.text,
      });
    }
  }
}
