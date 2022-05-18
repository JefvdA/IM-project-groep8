import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/screens/student/student_location_page.dart';
import 'package:flutter/material.dart';

import '../grade_exam.dart';

class GradeExamTab extends StatelessWidget {
  const GradeExamTab({Key? key}) : super(key: key);

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
                          trailing: Container(
                            width: 250,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.grading_rounded),
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
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  label: const Text("Beoordelen"),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.location_on_rounded),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                StudentLocationScreen(
                                                    data['location']['lat'],
                                                    data['location']['lon']),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  label: const Text("Locatie"),
                                ),
                              ],
                            ),
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
                                Text(
                                  "${data['score']} op ${data['maxScore']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "${data['needGrading']} vraag/vragen moeten nog verbeterd worden",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "de student heeft de apllicatie ${data['leftApplicationCount']} keer verlaten",
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
