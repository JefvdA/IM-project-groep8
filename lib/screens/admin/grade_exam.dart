import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GradeExam extends StatefulWidget {
  final sNummer;
  final answers;
  const GradeExam(this.sNummer, this.answers, {Key? key}) : super(key: key);
  @override
  State<GradeExam> createState() => _GradeExamState(this.sNummer);
}

class _GradeExamState extends State<GradeExam> {
  CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('results');
  var punten = "";
  final sNummer;
  _GradeExamState(this.sNummer);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('ExamAp'),
      ),
      body: Column(
        children: [
          const Text("Nog te beoordelen vragen"),
          StreamBuilder(
            stream: resultsCollection.doc(sNummer).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              } else {
                final answers = snapshot.data!['answers'];
                for (var i = 0; i < answers.length; i++) {
                  if (answers[i]['type'] == 'OQ' &&
                      answers[i]['graded'] == false) {
                    var value;
                    return Column(
                      children: [
                        ListTile(
                          title: Text(answers[i]['question']),
                          subtitle: Text(answers[i]['answer']),
                        ),
                        TextField(
                          onChanged: (text) async {
                            value = text;
                          },
                          decoration: InputDecoration(
                            labelText: "Score op ${answers[i]['points']} ",
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if(answers[i]['points'] >= int.parse(value)){}
                              resultsCollection.doc(sNummer).update({
                                'needGrading': await resultsCollection
                                    .doc(sNummer)
                                    .get()
                                    .then((doc) {
                                  return doc.get("needGrading") - 1;
                                }),
                                'score': await resultsCollection
                                    .doc(sNummer)
                                    .get()
                                    .then((doc) {
                                  return doc.get("score") + int.parse(value);
                                }),
                                "answers": await resultsCollection
                                    .doc(sNummer)
                                    .get()
                                    .then((doc) {
                                  var x = doc.get("answers");
                                  x[i]['graded'] = true;
                                  return x;
                                })
                              });
                            },
                            child: Text("Examen verbeteren"))
                      ],
                    );
                  }
                }
              }
              return Container(
                child: Text("Alle vragen zijn verbeterd"),
              );
            },
          ),
          StreamBuilder(
            stream: resultsCollection.doc(sNummer).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              final document = snapshot.data;
              return Column(children: [
                Text("De huidige score is ${document!["score"]}"),
                Text("De student heeft de app ${document["leftApplicationCount"]} keer verlaten"),
                TextFormField(
                  initialValue: document['score'].toString(),
                  onChanged: (text) {
                    punten = text;
                  },
                  decoration: InputDecoration(
                    labelText: "totalescore op ${document['maxScore']}",
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if(int.parse(punten) <= document['maxScore']){
                        resultsCollection
                          .doc(sNummer)
                          .update({"score": int.parse(punten)});
                      }
                    },
                    child: Text("Geef punten"))
              ]);
            },
          ),
        ],
      ),
    );
  }
}
