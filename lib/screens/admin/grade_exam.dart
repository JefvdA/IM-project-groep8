import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GradeExam extends StatelessWidget {
  final sNummer;
  final answers;
  GradeExam(this.sNummer, this.answers, {Key? key}) : super(key: key);
  CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('results');

  getAnswers() async {
    await resultsCollection
        .doc(sNummer)
        .get()
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      for (var i = 0; i < data['answers'].length; i++) {
        if (data['answers'][i]['type'] == 'MC') {
          if (data['answers'][i]['correctOption'].trim() ==
              data['answers'][i]['answer'].trim()) {}
        } else if (data['answers'][i]['type'] == 'CC') {
          if (data['answers'][i]['answer'].toLowerCase().trim() ==
              data['answers'][i]['correctCode'].toLowerCase().trim()) {}
        }
      }
    });
  }

  List<Widget> Answers() {
    List<Widget> list = [];
    for (var i = 0; i < answers.length; i++) {
      if (answers[i]['type'] == 'OQ') {
        list.add(
          Column(
            children: [
              Text(
                answers[i]['question'],
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                answers[i]['answer'],
                style: const TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Score op ${answers[i]['points']} ",
                ),
              ),
            ],
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    getAnswers();
    print(answers);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Beoordelen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: Answers()),
          ),
        ],
      ),
    );
  }
}
