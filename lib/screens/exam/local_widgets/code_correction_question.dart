import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CodeCorrectionQuestion extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> questionDoc;
  final AddAnswerCallback addAnswerCallback;
  const CodeCorrectionQuestion(this.questionDoc, this.addAnswerCallback, {Key? key}) : super(key: key);

  @override
  State<CodeCorrectionQuestion> createState() => _CodeCorrectionQuestionState();
}

class _CodeCorrectionQuestionState extends State<CodeCorrectionQuestion>{

  @override
  Widget build(BuildContext context) {
    return Column(
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
          widget.questionDoc.get('given_code'),
          style: const TextStyle(
            fontSize: 26,
            fontFamily: 'Roboto',
            color: Colors.black,
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: "Geef je antwoord in...",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1,
                  color: Colors.redAccent),
            ),
          ),
          onSaved: (String? value) {
            widget.addAnswerCallback(value);
          },
        ),
        if(widget.questionDoc.get('case_sensitive'))
          const Text(
            "Let op: verbetering op deze vraag is hoofdlettergevoelig!",
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}

typedef AddAnswerCallback = void Function(String? answer);