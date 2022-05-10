// ignore_for_file: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/repositories/current_student.dart';
import 'package:examap/screens/home/home_screen.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class _ExamScreenState extends State<ExamScreen> {
  String user = CurrentStudent.sNummer;
  List<String> colors = ["Rood", "Geel", "Blauw", "Zwart"];
  //timer
  static const countdownDuration = Duration(hours: 3);
  Duration _duration = const Duration();
  Timer? timer;

  bool isCountdown = true;

  get headerColor => null;

  @override
  void initState() {
    super.initState();

    startTimer();
    reset();
  }

  void reset() {
    if (isCountdown) {
      setState(() => _duration = countdownDuration);
    } else {
      setState(() => _duration = const Duration());
    }
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = _duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  CollectionReference location =
      FirebaseFirestore.instance.collection("students");
  CollectionReference examsCollection = FirebaseFirestore.instance
      .collection('exams')
      .doc('Intro Mobile')
      .collection("vragen");
  askPermission() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    await location
        .doc(CurrentStudent.sNummer)
        .update({"lat": position.latitude, "lon": position.longitude});
  }

  @override
  Widget build(BuildContext context) {
    askPermission();
    return Scaffold(
      appBar: globalAppBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTime(),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 204, 202, 202),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: FutureBuilder(
                        future: examsCollection.get(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<Step> stepsen = [];
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              if (snapshot.data.docs[i]['type'] ==
                                  'Multiple choice') {
                                stepsen.add(
                                  Step(
                                    title: Text(
                                      'Vraag${i + 1} : ${snapshot.data.docs[i]['type']}',
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
                                            snapshot.data.docs[i]['vraag'],
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontFamily: 'Roboto',
                                              color: Colors.black,
                                            ),
                                          ),
                                          _choiceBuild(
                                              snapshot.data.docs[i]['opties']),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                stepsen.add(
                                  Step(
                                    title: Text(
                                      'Vraag${i + 1} : ${snapshot.data.docs[i]['type']}',
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
                                            snapshot.data.docs[i]['vraag'],
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontFamily: 'Roboto',
                                              color: Colors.black,
                                            ),
                                          ),
                                          const TextField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Geef je antwoord in...",
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.redAccent),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            ;
                            return Stepper(
                              steps: stepsen,
                              controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
        return Row(
          children: <Widget>[
            TextButton(
              onPressed: controlsDetails.onStepContinue,
              child: const Text('NEXT'),
            ),
            TextButton(
              onPressed: controlsDetails.onStepCancel,
              child: const Text('PREVIOUS'),
            ),
          ],
        );
      },
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index >= 0) {
          setState(() {
            _index += 1;
            if (_index == 3) {
              _index -= 1;
            }
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
                            );
                          } else
                            return CircularProgressIndicator();
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const HomeScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Examen indienen"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours),
        const SizedBox(width: 5),
        buildTimeCard(time: minutes),
        const SizedBox(width: 5),
        buildTimeCard(time: seconds),
      ],
    );
  }

  Widget buildTimeCard({required String time}) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );

  int _index = 0;

  int? _value = 1;
  Widget _choiceBuild(value) {
    return Wrap(
      children: List<Widget>.generate(
        4,
        (int index) {
          return ChoiceChip(
            label: Text(value[index]),
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
