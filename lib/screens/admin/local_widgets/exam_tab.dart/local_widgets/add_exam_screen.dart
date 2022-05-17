import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/add_questions/add_questions_screen.dart';
import 'package:examap/services/authentication_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExamScreen extends StatefulWidget {
  const AddExamScreen({Key? key}) : super(key: key);

  @override
  State<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {

  final CollectionReference examCollection =
    FirebaseFirestore.instance.collection('exams');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
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
            const Text(
              "Bestaande examens",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            StreamBuilder(
              stream: examCollection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          snapshot.data.docs[index].data()['name'],
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddQuestionsScreen(
                                  snapshot.data.docs[index].data()['name']),
                            ),
                          );
                        },
                      );
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
              "Creëer een nieuw examen",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Examennaam',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(onPressed: addExam, child: const Text('Toevoegen')),
          ],
        ),
      ),
    );
  }

  void addExam() {
    examCollection.doc(_nameController.text).set(
      {
        'name': _nameController.text,
        'description': _descriptionController.text,
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddQuestionsScreen(_nameController.text)),
    );
  }
}
