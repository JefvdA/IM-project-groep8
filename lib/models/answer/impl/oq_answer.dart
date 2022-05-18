import 'package:examap/models/answer/answer.dart';

class OQAnswer extends Answer {
  final String answer;

  OQAnswer(String question, String type, int points, this.answer)
      : super(question, type, points);

  Map<String, dynamic> toJson() => {
    'question': question,
    'type': type,
    'points': points,
    'answer': answer,
    'graded': false
  };
}
