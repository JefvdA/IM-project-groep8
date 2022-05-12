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
        child: Text(
          "Open vraag",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "Open vraag",
      ),
      const DropdownMenuItem(
        child: Text(
          "Multiple choice",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "Multiple choice",
      ),
      const DropdownMenuItem(
        child: Text(
          "Code correction",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "Code correction",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamAP'),
      ),
      body: Column(
        children: [
          const Text(
            "Bestaande vragen",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          StreamBuilder(
            stream:
                examsCollection.doc(this.exam).collection('vragen').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(
                          snapshot.data.docs[index].data()['vraag'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 124, 0, 0),
                          ),
                        ),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const Text(
            "Creëer een nieuwe vraag",
            style: TextStyle(
              fontSize: 26,
              color: Colors.grey,
            ),
          ),
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
