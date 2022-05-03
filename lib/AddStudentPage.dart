// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Column(children: [
              const Text('Add Student'),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: const Text("Sign out"),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
