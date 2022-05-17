import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GradeExam extends StatelessWidget {
  final sNummer;
  final answers;
  GradeExam(this.sNummer, this.answers, {Key? key}) : super(key: key);
  CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('results');
  List<Widget> Answers() {
    List<Widget> list = [];
    for (var i = 0; i < answers.length; i++) {
      if (answers[i]['type'] == 'OQ') {
        list.add(
          Column(
            children: [
              ListTile(
                title: Text(answers[i]['question']),
                subtitle: Text(answers[i]['answer']),
              ),
              TextField(
                onSubmitted: (text) async {
                  resultsCollection.doc(sNummer).update({
                    'score':
                        await resultsCollection.doc(sNummer).get().then((doc) {
                      return doc.get("score") + int.parse(text);
                    }),
                  });
                },
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Beoordelen'),
      ),
      body: Column(
        children: [
          const Text("Nog te beoordelen vragen"),
          ListView(
            children: Answers(),
            shrinkWrap: true,
          ),
          StreamBuilder(
            stream: resultsCollection.doc(sNummer).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              final document = snapshot.data;
              return Text(
                'Score: ${document!['score']}',
                style: const TextStyle(fontSize: 20),
              );
            },
          ),
          TextField(
            onSubmitted: (text) async {
              resultsCollection.doc(sNummer).update({'score': int.parse(text)});
            },
            decoration: InputDecoration(
              labelText: "zet de totalescore",
            ),
          ),
        ],
      ),
    );
  }
}
