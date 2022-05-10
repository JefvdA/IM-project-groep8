// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListStudent extends StatelessWidget {
  const ListStudent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamAp',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ListOfStudent(),
    );
  }
}

var _selectedValue;
var setDefaultValue = true;
var testing = "";

class ListOfStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ExamAP'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (setDefaultValue) {
                      _selectedValue = snapshot.data!.docs[0].get("s-nummer");
                    }

                    return ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            contentPadding: const EdgeInsets.all(8),
                            title: Center(
                                child: Text(
                              data['s-nummer'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto',
                                color: Colors.red,
                              ),
                            )),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ));
  }
}
