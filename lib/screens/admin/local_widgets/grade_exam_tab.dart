import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../grade_exam.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference resultsCollection =
        FirebaseFirestore.instance.collection('results');
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: resultsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          trailing: ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          GradeExam(
                                    data['student'],
                                    data['answers'],
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            label: const Text("Beoordelen"),
                          ),
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
                    },
                  ).toList(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
