import 'dart:collection';

import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final LinkedHashMap<String, dynamic> questionDoc;
  const MultipleChoiceQuestion(this.questionDoc, { Key? key }) : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  int? _value = 1;

  @override
  Widget build(BuildContext context){
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
          _choiceBuild(
              widget.questionDoc['options']
          ),
        ],
      ),
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
}
