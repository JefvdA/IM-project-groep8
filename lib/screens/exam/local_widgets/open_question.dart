import 'package:cloud_firestore/cloud_firestore.dart';
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
        Text(
          widget.questionDoc.get('question'),
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
      ],
    );
  }
}

typedef AddAnswerCallback = void Function(String? answer);