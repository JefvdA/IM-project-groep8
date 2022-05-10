// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/exam/exam_greeting_screen.dart';
import 'package:examap/repositories/current_student.dart';
import 'package:flutter/material.dart';

class StudentSignInTab extends StatefulWidget {
  const StudentSignInTab({Key? key}) : super(key: key);

  @override
  State<StudentSignInTab> createState() => _StudentSignInTabState();
}

class _StudentSignInTabState extends State<StudentSignInTab> {
  // ignore: prefer_typing_uninitialized_variables
  var _selectedValue;
  var setDefaultValue = true;
  var testing = "";

  @override
  Widget build(BuildContext context) {
    final _dropdownFormKey = GlobalKey<FormState>();

    var elevatedButton = ElevatedButton(
      onPressed: () {
        CurrentStudent.sNummer = _selectedValue;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const GreetingScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: const Icon(Icons.login_rounded, size: 40),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
      ),
    );
    return Center(
      child: Form(
        key: _dropdownFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
            ),
            const Text(
              "Login als student:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.red,
              ),
            ),
            const Text("Gebruik je s-nummer om in te loggen",
                style: TextStyle(fontSize: 16)),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
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
                            value.get('s-nummer') + " - " + value.get('name'),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
            elevatedButton,
          ],
        ),
      ),
    );
  }
}
