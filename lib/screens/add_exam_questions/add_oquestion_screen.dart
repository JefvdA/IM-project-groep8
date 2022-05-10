// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AddOQuestionScreen extends StatefulWidget {
  const AddOQuestionScreen({Key? key}) : super(key: key);

  @override
  State<AddOQuestionScreen> createState() => _AddOQuestionScreenState();
}

class _AddOQuestionScreenState extends State<AddOQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExamAP'),
      ),
      body: Center(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Voeg Open Vraag toe :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.red,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 600,
                      height: 80,
                      child: const TextField(
                        decoration: InputDecoration(
                          label: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: Text(
                                    'Vraagstelling',
                                  ),
                                ),
                                WidgetSpan(
                                  child: Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 400,
                      height: 30,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save_alt_rounded,
                          size: 30,
                        ),
                        label: const Text("VRAAG OPSLAAN",
                            style: TextStyle(fontSize: 24)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
