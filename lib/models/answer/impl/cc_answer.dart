import 'package:examap/models/answer/answer.dart';

class CCAnswer extends Answer {
  final String givenCode;
  final String correctCode;
  final bool caseSensitive;
  final String answer;

  CCAnswer(String question, String type, int points, this.givenCode, this.correctCode, this.caseSensitive, this.answer) : super(question, type, points);
}