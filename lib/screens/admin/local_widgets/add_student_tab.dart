// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:examap/services/authentication_service.dart';
import 'package:examap/screens/student_list/student_list_screen.dart';

class AddStudentsTab extends StatefulWidget {
  const AddStudentsTab({Key? key}) : super(key: key);

  @override
  State<AddStudentsTab> createState() => _AddStudentsTabState();
}

var setDefaultValue = true;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text(
              "Sign out",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Center(
          heightFactor: 1,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                width: 1000,
                height: 200,
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
                child: const Text("Add students \u{2795}"),
              ),
              ElevatedButton(
                onPressed: () {
                  _loadCsv();
                },
                child: const Text("Load students from csv"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const StudentListScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: const Text("Show list"),
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
                    _message = "${lines.length} studenten toegevoegd.";
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
              "Er is iets fout gegaan bij het toevoegen van de studenten, check je meegegeven data.";
          _messageStyle = const TextStyle(
            color: Colors.red,
          );
        });
      }
    }
  }

  Future<void> _loadCsv() async {
    final _rawData = await rootBundle.loadString("Students.csv");
    csvController.text = _rawData;
  }
}
