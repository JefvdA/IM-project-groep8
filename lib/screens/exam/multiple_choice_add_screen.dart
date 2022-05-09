// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MCExam extends StatelessWidget {
  const MCExam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamAp',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: _MCAddExam(),
    );
  }
}

class _MCAddExam extends StatelessWidget {
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
                "Voeg Multiple Choice vraag toe :",
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
                      width: 600,
                      height: 80,
                      child: const TextField(
                        decoration: InputDecoration(
                          label: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: Text(
                                    'Antwoorden  gescheiden zijn door ;',
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
                      width: 600,
                      height: 80,
                      child: const TextField(
                        decoration: InputDecoration(
                          label: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                WidgetSpan(
                                  child: Text(
                                    'Oplossing',
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MCExam()),
                          );
                        },
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
