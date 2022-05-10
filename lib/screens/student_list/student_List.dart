// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class ListStudent extends StatelessWidget {
  const ListStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamAp',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const ListOfStudent(),
    );
  }
}

var setDefaultValue = true;

class ListOfStudent extends StatefulWidget {
  const ListOfStudent({Key? key}) : super(key: key);

  @override
  State<ListOfStudent> createState() => _ListOfStudentState();
}

class _ListOfStudentState extends State<ListOfStudent> {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: studentsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                          label: const Text(""),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                        title: Center(
                          child: Column(
                            children: [
                              Text(
                                data['s-nummer'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data['name'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  void removeStudent() {}
}
