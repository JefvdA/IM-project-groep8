// ignore_for_file: file_names

import 'package:examap/screens/exam/exam_screen.dart';

import 'package:flutter/material.dart';

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({Key? key}) : super(key: key);

  @override
  State<GreetingScreen> createState() => GreetingScreenState();
}

class GreetingScreenState extends State<GreetingScreen> {
  // ignore: prefer_typing_uninitialized_variables

  var setDefaultValue = true;
  var testing = "";

  @override
  Widget build(BuildContext context) {
    final _dropdownFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ExAmIn.ap'),
      ),
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
              const Text(
                  'Het examen bestaat uit één onderdeel dat meerder oefeningen bevat. Lees de oefeningen goed en zorg ervoor dat je ze correct maakt.\n'
                  'Je hebt 3u de tijd om je examen te maken en in te dienen. Zorg ervoor dat je op tijd je examen indient !',
                  style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExamScreen()),
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
