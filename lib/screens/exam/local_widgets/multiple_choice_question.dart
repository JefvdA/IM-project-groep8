import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/models/answer/answer.dart';
import 'package:examap/models/answer/impl/mc_answer.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> questionDoc;
  final AddAnswerCallback addAnswerCallback;
  const MultipleChoiceQuestion(this.questionDoc, this.addAnswerCallback, { Key? key }) : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  int? _value = 1;

  @override
  Widget build(BuildContext context){
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
        FormField(
          builder: (FormFieldState<dynamic> field) { 
            return _choiceBuild(
              widget.questionDoc.get('options'),
            );
          }, 
          onSaved: (_) {
            saveAnswer(widget.questionDoc.get('options')[_value]);
          },
        ),
      ],
    );
  }

  Widget _choiceBuild(options) {
    return Wrap(
      children: List<Widget>.generate(4, (int i) {
          return ChoiceChip(
            label: Text(options[i]),
            selected: _value == i,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? i : null;
              });
            },
          );
        },
      ).toList(),
    );
  }

  void saveAnswer(answer) {
    String question = widget.questionDoc.get('question');
    String type = widget.questionDoc.get('type');
    int points = widget.questionDoc.get('points');
    List<dynamic> options = widget.questionDoc.get('options');
    String correctOption = widget.questionDoc.get('correct_option');
    MCAnswer thisAnswer = MCAnswer(question, type, points, options, correctOption, answer);
    widget.addAnswerCallback(thisAnswer);
  }
}

typedef AddAnswerCallback = void Function(Answer answer);
