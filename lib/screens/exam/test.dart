import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController textarea = TextEditingController();
  int _index = 0;
  TextEditingController textarea2 = TextEditingController();
  List<String> colors = ["Rood", "Geel", "Blauw", "Zwart"];
  CollectionReference examsCollection = FirebaseFirestore.instance
      .collection('exams')
      .doc('Intro Mobile')
      .collection("vragen");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: examsCollection.get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data.docs[index]['type'] == 'Open vraag') {
                        return Column(
                          children: [
                            Text(snapshot.data.docs[index]['vraag'],
                                style: TextStyle(fontSize: 20)),
                            TextField(
                                controller: textarea,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                    hintText: "Geef je antwoord in...",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.redAccent))))
                          ],
                        );
                      } else if (snapshot.data.docs[index]['type'] ==
                          'Multiple choice') {
                        return Column(
                          children: [
                            Text(snapshot.data.docs[index]['vraag'],
                                style: TextStyle(fontSize: 20)),
                            _choiceBuild(snapshot.data.docs[index]['opties']),
                          ],
                        );
                      } else if (snapshot.data.docs[index]['type'] ==
                          'Code correction') {
                        return Column(
                          children: [
                            Text(snapshot.data.docs[index]['vraag'],
                                style: TextStyle(fontSize: 20)),
                            TextField(
                              controller: textarea2,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: "Geef je antwoord in...",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            ),
            Stepper(
                steps: <Step>[
                  Step(
                    title: const Text(
                      'Vraag1 : Open vraag',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    content: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text(
                              'Wat is het beste framework ?',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                            TextField(
                                controller: textarea,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                    hintText: "Geef je antwoord in...",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.redAccent))))
                          ],
                        )),
                  ),
                  Step(
                    title: const Text(
                      'Vraag2 : Multiple choice',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    content: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text(
                              'Wat is de mooiste kleur ?',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                            _choiceBuild(colors),
                          ],
                        )),
                  ),
                  Step(
                    title: const Text(
                      'Vraag3 : Code correction',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      ),
                    ),
                    content: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text(
                              'Hoe scrhrijf jr irts naar je console in C# ?',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                              ),
                            ),
                            TextField(
                                controller: textarea2,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                    hintText: "Geef je antwoord in...",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.redAccent))))
                          ],
                        )),
                  ),
                ],
                currentStep: _index,
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
                  });
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Step>> GetData() async {
    List<Step> StepList = [];
    int i = 0;
    await examsCollection.get().then((value) {
      for (i = 1; i <= 2; i++) {
        if (value.docs[i]['type'] == 'Open vraag') {
          StepList.add(
            Step(
              title: Text(
                'Vraag $i : Open vraag',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
              content: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        value.docs[i]['vraag'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      TextField(
                          controller: textarea,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              hintText: "Geef je antwoord in...",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent))))
                    ],
                  )),
            ),
          );
        }
        if (value.docs[i]['type'] == 'Multiple choice') {
          StepList.add(
            Step(
              title: Text(
                'Vraag $i : Multiple choice',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
              content: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        value.docs[i]['vraag'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      _choiceBuild(value.docs[i]['opties'])
                    ],
                  )),
            ),
          );
        }
        if (value.docs[i]['type'] == 'Code correction') {
          StepList.add(
            Step(
              title: Text(
                'Vraag $i : Code correction',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
              content: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        value.docs[i]['vraag'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      TextField(
                          controller: textarea,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              hintText: "Geef je antwoord in...",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.redAccent))))
                    ],
                  )),
            ),
          );
        }
      }
    });
    return StepList;
  }

  int? _value = 1;
  Widget _choiceBuild(colors) {
    return Wrap(
      children: List<Widget>.generate(
        4,
        (int index) {
          return ChoiceChip(
            label: Text(colors[index]),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }
}
