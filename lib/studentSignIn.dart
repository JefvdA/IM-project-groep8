// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/ExamPage.dart';
import 'package:examap/Location.dart';
import 'package:examap/test.dart';
import 'package:flutter/material.dart';

class StudentSignInPage extends StatefulWidget {
  const StudentSignInPage({Key? key}) : super(key: key);

  @override
  State<StudentSignInPage> createState() => _StudentSignInPageState();
}

class _StudentSignInPageState extends State<StudentSignInPage> {
  // ignore: prefer_typing_uninitialized_variables
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
                    if (snapshot.hasData) {
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
                    }
                    else {
                      return Container();
                    }
                    
                  }),
              ElevatedButton(
                  onPressed: () {
                    var x = LoggedIn();
                    x.setSNummer(_selectedValue);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExamPage()),
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
