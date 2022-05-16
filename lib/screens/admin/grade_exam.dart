import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GradeExam extends StatelessWidget {
  final sNummer;
  final answers;
  GradeExam(this.sNummer, this.answers, {Key? key}) : super(key: key);
  CollectionReference examsCollection =
      FirebaseFirestore.instance.collection('exams');
  CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('results');
  int totalScore = 0;

  getAnswers() async {
    await resultsCollection
        .doc(sNummer)
        .get()
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      for (var i = 0; i < data['answers'].length; i++) {
        if (data['answers'][i]['type'] == 'MC') {
          if (data['answers'][i]['correctOption'].trim() ==
              data['answers'][i]['answer'].trim()) {
            totalScore += data['answers'][i]['points'] as int;
          }
        } else if (data['answers'][i]['type'] == 'CC') {
          if (data['answers'][i]['answer'].toLowerCase().trim() ==
              data['answers'][i]['correctCode'].toLowerCase().trim()) {
            totalScore += data['answers'][i]['points'] as int;
          }
        }
      }
    });
    print(totalScore);
  }

  @override
  Widget build(BuildContext context) {
    getAnswers();
    return Column(
      children: [],
    );
  }
}
