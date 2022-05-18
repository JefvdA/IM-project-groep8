import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/models/answer/answer.dart';
import 'package:examap/models/answer/impl/oq_answer.dart';
import 'package:flutter/material.dart';

class OpenQuestion extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> questionDoc;
  final AddAnswerCallback addAnswerCallback;
  const OpenQuestion(this.questionDoc, this.addAnswerCallback, {Key? key}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }

  void saveAnswer(answer) {
    String question = widget.questionDoc.get('question');
    String type = widget.questionDoc.get('type');
    int points = widget.questionDoc.get('points');
    OQAnswer thisAnswer = OQAnswer(question, type, points, answer);
    widget.addAnswerCallback(thisAnswer);
  }
}

typedef AddAnswerCallback = void Function(Answer answer);