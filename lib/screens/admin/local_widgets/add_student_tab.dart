// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:examap/services/authentication_service.dart';

class AddStudentsTab extends StatefulWidget {
  const AddStudentsTab({Key? key}) : super(key: key);

  @override
  State<AddStudentsTab> createState() => _AddStudentsTabState();
}

class _AddStudentsTabState extends State<AddStudentsTab> {
  String _message = "";
  TextStyle _messageStyle = const TextStyle(
    color: Colors.green,
  );

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  final TextEditingController csvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text("Sign out"),
          ),
        ),
        Center(
          heightFactor: 1,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                width: 1000,
                height: 300,
                child: TextField(
                  maxLines: 10,
                  controller: csvController,
                  decoration: const InputDecoration(
                    labelText: "CSV data for new students",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Text(_message, style: _messageStyle),
              ElevatedButton(
                onPressed: () {
                  _addStudents();
                },
                child: const Text("Add students"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addStudents() {
    // Read csv data from the text field.
    final String csv = csvController.text;
    final List<String> lines = csv.split("\n");
    // Loop through each line of the csv data.
    for (var line in lines) {
      try {
        final List<String> fields = line.split(",");
        // Get the student's name and sNummer.
        final String name = fields[1];
        final String sNummer = fields[0];

        // Add the student to the database.
        studentsCollection.doc(sNummer).set({
          'name': name,
          's-nummer': sNummer,
        })
            // Show a message if the students were added successfully.
            // Reset the text field.
            .then((value) => {
                  setState(() {
                    _message = "${lines.length} students added.";
                    _messageStyle = const TextStyle(
                      color: Colors.green,
                    );
                  }),
                  csvController.text = ""
                });
      } catch (e) {
        // Show a message if the students were not added.
        setState(() {
          _message =
              "Something went wrong, please check the data you provided!";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      }
    }
  }
}
