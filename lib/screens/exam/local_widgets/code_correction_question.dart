import 'dart:collection';

import 'package:flutter/material.dart';

class CodeCorrectionQuestion extends StatefulWidget {
  final LinkedHashMap<String, dynamic> questionDoc;
  const CodeCorrectionQuestion(this.questionDoc, {Key? key}) : super(key: key);

  @override
  State<CodeCorrectionQuestion> createState() => _CodeCorrectionQuestionState();
}

class _CodeCorrectionQuestionState extends State<CodeCorrectionQuestion>{

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Verbeter de volgende code:",
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
          ),
          Text(
            widget.questionDoc['given_code'],
            style: const TextStyle(
              fontSize: 26,
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
          ),
          const TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Geef je antwoord in...",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: Colors.redAccent),
              ),
            ),
          ),
          if(widget.questionDoc['case_sensitive'])
            const Text(
              "Let op: verbetering op deze vraag is hoofdlettergevoelig!",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
