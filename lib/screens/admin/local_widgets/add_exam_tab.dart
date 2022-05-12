
// ignore_for_file: file_names

import 'package:examap/screens/add_exam_question_screen/add_ccquestion_screen.dart';
import 'package:examap/screens/add_exam_question_screen/add_mcquestion_screen.dart';
import 'package:examap/screens/add_exam_question_screen/add_oquestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/authentication_service.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/admin/local_widgets/add_questions_tab.dart';
import 'package:examap/services/authentication_service.dart';

class AddExamTab extends StatefulWidget {
  const AddExamTab({Key? key}) : super(key: key);

  @override
  State<AddExamTab> createState() => _AddExamTabState();
}

class _AddExamTabState extends State<AddExamTab> {
    TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          heightFactor: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: const Text(
                  "Afmelden",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddOQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text(
                  "OPEN VRAAG",
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddMCQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text("MULTIPLE CHOICE",
                    style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const AddCCQuestionScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                label: const Text("CODE CORRECTIE",
                    style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
          Text("Bestaande examens"),
          StreamBuilder(
            stream: examsCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data.docs[index].data()['name']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionsTab(
                                snapshot.data.docs[index].data()['name']),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Text("Creer een nieuw examen"),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Examennaam',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          ElevatedButton(onPressed: addExam, child: Text('Toevoegen')),
        ],
      ),
    );
  }

  void addExam() {
    examsCollection.doc(_nameController.text).set(
      {
        'name': _nameController.text,
        'description': _descriptionController.text,
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddQuestionsTab(_nameController.text)),
    );
  }
}
