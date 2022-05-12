// ignore_for_file: file_names
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';

class AddCCQuestionScreen extends StatefulWidget {
  const AddCCQuestionScreen({Key? key}) : super(key: key);

  @override
  State<AddCCQuestionScreen> createState() => _AddCCQuestionScreenState();
}

class _AddCCQuestionScreenState extends State<AddCCQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar,
      body: Center(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Voeg Code Correctie vraag toe :",
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
                                    'CodeVraag',
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
                                    'Correcte Code',
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
