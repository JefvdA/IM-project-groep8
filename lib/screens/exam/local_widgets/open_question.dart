import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OpenQuestion extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> questionDoc;
  const OpenQuestion(this.questionDoc, {Key? key}) : super(key: key);

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {

  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            widget.questionDoc.get('question'),
            style: const TextStyle(
              fontSize: 26,
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
          ),
          TextField(
            controller: _answerController,
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
          ),
        ],
      ),
    );
  }
}