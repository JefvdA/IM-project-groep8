import 'package:examap/models/answer/answer.dart';

class MCAnswer extends Answer {
  final List<dynamic> options;
  final String correctOption;
  final String answer;

  MCAnswer(String question, String type, int points, this.options, this.correctOption, this.answer) : super(question, type, points);
}