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

  @override
  Widget build(BuildContext context) {
    getAnswers();
    return Column(
      children: [
        StreamBuilder(
          stream: resultsCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  print(data);
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Center(
                        child: Column(
                          children: [
                            Text(
                              data['student'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Text('Loading');
            }
          },
        ),
      ],
    );
  }
}
