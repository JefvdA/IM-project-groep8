import 'dart:collection';

import 'package:flutter/material.dart';

class OpenQuestion extends StatefulWidget {
  final LinkedHashMap<String, dynamic> questionDoc;
  const OpenQuestion(this.questionDoc, {Key? key}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            widget.questionDoc['question'],
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
        ],
      ),
    );
  }
}
