import 'package:examap/models/answer/answer.dart';

class MCAnswer extends Answer {
  final List<dynamic> options;
  final String correctOption;
  final String answer;

  MCAnswer(String question, String type, int points, this.options,
      this.correctOption, this.answer)
      : super(question, type, points);

  Map toJson() => {
        'question': question,
        'type': type,
        'points': points,
        'options': options,
        'correctOption': correctOption,
        'answer': answer,
      };
  int automaticCodeCorrection() {
    if (answer.toLowerCase().trim() == correctOption.toLowerCase().trim()) {
      return points;
    } else {
      return 0;
    }
  }
}
