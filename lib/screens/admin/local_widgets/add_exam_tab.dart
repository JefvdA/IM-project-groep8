
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/admin/local_widgets/add_questions_tab.dart';
import 'package:examap/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Container(
      child: Column(
        children: [
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
