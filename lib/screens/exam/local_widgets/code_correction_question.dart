import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/models/answer/answer.dart';
import 'package:examap/models/answer/impl/cc_answer.dart';
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
            saveAnswer(value);
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

  void saveAnswer(answer) {
    String question = widget.questionDoc.get('question');
    String type = widget.questionDoc.get('type');
    int points = widget.questionDoc.get('points');
    String givenCode = widget.questionDoc.get('given_code');
    String correctCode = widget.questionDoc.get('correct_code');
    bool caseSensitive = widget.questionDoc.get('case_sensitive');
    CCAnswer thisAnswer = CCAnswer(question, type, points, givenCode, correctCode, caseSensitive, answer);
    widget.addAnswerCallback(thisAnswer);
  }
}

typedef AddAnswerCallback = void Function(Answer answer);