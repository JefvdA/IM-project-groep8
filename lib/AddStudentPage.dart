// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  final TextEditingController csvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
    );
  }

  void _addStudents() {
    final String csv = csvController.text;
    final List<String> lines = csv.split("\n");
    for (var line in lines) {
      final List<String> fields = line.split(",");
      if (fields.length != 2) {
        return;
      }
      final String name = fields[1];
      final String sNummer = fields[0];
      studentsCollection.add({
        'name': name,
        'sNummer': sNummer,
      });
    }
  }
}
