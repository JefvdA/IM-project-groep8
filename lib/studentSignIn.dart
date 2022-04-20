import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/Exam.dart';
import 'package:examap/test.dart';
import 'package:flutter/material.dart';

class StudentSignIn extends StatefulWidget {
  const StudentSignIn({Key? key}) : super(key: key);

  @override
  State<StudentSignIn> createState() => _StudentSignInState();
}

class _StudentSignInState extends State<StudentSignIn> {
  var _selectedValue;
  var setDefaultValue = true;
  var testing = "";

  @override
  Widget build(BuildContext context) {
    final _dropdownFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Form(
          key: _dropdownFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login als student:"),
              const Text("Gebruik je s-nummer om in te loggen"),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (setDefaultValue) {
                      _selectedValue = snapshot.data!.docs[0].get("s-nummer");
                    }
                    return DropdownButton(
                      value: _selectedValue,
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                          setDefaultValue = false;
                        });
                      },
                      items: snapshot.data!.docs.map((value) {
                        return DropdownMenuItem<String>(
                          value: value.get('s-nummer'),
                          child: Text(
                            value.get('s-nummer'),
                          ),
                        );
                      }).toList(),
                    );
                  }),
              ElevatedButton(
                  onPressed: () {
                    var x = LoggedIn();
                    x.setSNummer(_selectedValue);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Exam()),
                    );
                  },
                  child: const Text("Log in")),
            ],
          ),
        ),
      ),
    );
  }
}
