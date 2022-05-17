import 'package:examap/screens/edit_questions/edit_questions_tab.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:examap/screens/add_questions/local_widgets/add_code_correction_form.dart';
import 'package:examap/screens/add_questions/local_widgets/add_multiple_choice_form.dart';
import 'package:examap/screens/add_questions/local_widgets/add_open_question_form.dart';

class AddQuestionsScreen extends StatefulWidget {
  final String exam;
  const AddQuestionsScreen(this.exam, {Key? key}) : super(key: key);

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  
  final CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');

  String _selectedValue = "OQ";

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem(
        child: Text(
          "Open vraag",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "OQ",
      ),
      const DropdownMenuItem(
        child: Text(
          "Multiple choice",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "MC",
      ),
      const DropdownMenuItem(
        child: Text(
          "Code correction",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        value: "CC",
      ),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Bestaande vragen",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            StreamBuilder(
              stream: examsCollection
                  .doc(widget.exam)
                  .collection('questions')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(
                            snapshot.data.docs[index].data()['question'],
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 124, 0, 0),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditQuestionsScreen(
                                    widget.exam,
                                    snapshot.data.docs[index].id,
                                    snapshot.data.docs[index].data()),
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
                items: items,
                onChanged: (String? value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                }),
            if (_selectedValue == "OQ")
              AddOpenQuestionForm(widget.exam)
            else if (_selectedValue == "MC")
              AddMultipleChoiceForm(widget.exam)
            else if (_selectedValue == "CC")
              AddCodeCorrectionForm(widget.exam)
          ],
        ),
      ),
    );
  }
}
