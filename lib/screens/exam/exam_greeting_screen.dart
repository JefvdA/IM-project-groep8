// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/exam/exam_screen.dart';
import 'package:examap/widgets/global_app_bar.dart';

import 'package:flutter/material.dart';

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({Key? key}) : super(key: key);

  @override
  State<GreetingScreen> createState() => GreetingScreenState();
}

class GreetingScreenState extends State<GreetingScreen> {
  // ignore: prefer_typing_uninitialized_variables

  var setDefaultValue = true;

  @override
  Widget build(BuildContext context) {
    final _dropdownFormKey = GlobalKey<FormState>();
    CollectionReference examsCollection =
        FirebaseFirestore.instance.collection('exams');

    return Scaffold(
      appBar: globalAppBar,
      body: Center(
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
                "Intro Mobile Examen !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.red,
                ),
              ),
              FutureBuilder(
                future: examsCollection.get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.docs[0]['description'],
                        style: TextStyle(fontSize: 20));
                  }
                  return CircularProgressIndicator();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const ExamScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Icon(Icons.run_circle_rounded, size: 40),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
