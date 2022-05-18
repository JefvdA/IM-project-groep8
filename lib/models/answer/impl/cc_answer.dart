import 'package:examap/models/answer/answer.dart';

class CCAnswer extends Answer {
  final String givenCode;
  final String correctCode;
  final bool caseSensitive;
  final String answer;

  CCAnswer(String question, String type, int points, this.givenCode,
      this.correctCode, this.caseSensitive, this.answer)
      : super(question, type, points);

  Map<String, dynamic> toJson() => {
    'question': question,
    'type': type,
    'points': points,
    'givenCode': givenCode,
    'correctCode': correctCode,
    'caseSensitive': caseSensitive,
    'answer': answer,
  };
  int automaticCodeCorrection() {
    if (caseSensitive) {
      if (answer.trim() == correctCode.trim()) {
        return points;
      } else {
        return 0;
      }
    } else {
      if (answer.trim().toLowerCase() == correctCode.trim().toLowerCase()) {
        return points;
      } else {
        return 0;
      }
    }
  }
}
