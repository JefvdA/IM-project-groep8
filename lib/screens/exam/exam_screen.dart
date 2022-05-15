// ignore_for_file: file_names
import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:examap/widgets/global_app_bar.dart';
import 'package:examap/main.dart';

import 'package:examap/repositories/current_student.dart';

import 'package:examap/screens/exam/local_widgets/code_correction_question.dart';
import 'package:examap/screens/exam/local_widgets/multiple_choice_question.dart';
import 'package:examap/screens/exam/local_widgets/open_question.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  String user = CurrentStudent.sNummer;

  //timer
  static const countdownDuration = Duration(hours: 3);
  Duration _duration = const Duration();
  Timer? timer;
  bool isCountdown = true;

  int _index = 0;

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

    if (mounted) {
      setState(() {
        final seconds = _duration.inSeconds + addSeconds;
        if (seconds < 0) {
          timer?.cancel();
        } else {
          _duration = Duration(seconds: seconds);
        }
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference examsCollection = FirebaseFirestore.instance
      .collection('exams')
      .doc('Intro mobile')
      .collection("questions");

  askPermission() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    await studentsCollection
        .doc(CurrentStudent.sNummer)
        .update({"lat": position.latitude, "lon": position.longitude});
  }

  @override
  Widget build(BuildContext context) {
    askPermission();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: globalAppBar,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTime(),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 204, 202, 202),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: examsCollection.get(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<Step> stepsen = [];
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                                stepsen.add(
                                  Step(
                                    title: Text(
                                      '${snapshot.data.docs[i].data()["question"]}',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto',
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: _buildQuestion(snapshot.data.docs[i].data()),
                                  ),
                                );
                            }
                            return Stepper(
                              steps: stepsen,
                              controlsBuilder: (BuildContext context,
                                  ControlsDetails controlsDetails) {
                                return Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: controlsDetails.onStepCancel,
                                      child: const Text(
                                        'Vorige',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: controlsDetails.onStepContinue,
                                      child: const Text(
                                        'Volgende',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.red,
                                        ),
                                      ),
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
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const MyApp(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                          (Route<dynamic> route) => false,
                        );
                        endExam();
                      },
                      child: const Text("Examen indienen"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeCard(time: hours),
        const SizedBox(width: 2),
        _buildTimeCard(time: minutes),
        const SizedBox(width: 2),
        _buildTimeCard(time: seconds),
      ],
    );
  }

  Widget _buildTimeCard({required String time}) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
      ],
    ); 

  Widget _buildQuestion(LinkedHashMap<String, dynamic> question) {
    switch (question['type']) {
      case "MC":
        return MultipleChoiceQuestion(question);
      case "OQ":
        return OpenQuestion(question);
      case "CC":
        return CodeCorrectionQuestion(question);
      default:
        return Container();
    }
  }

  endExam() {
    // Remove student from students collection
    studentsCollection.doc(CurrentStudent.sNummer).delete();
  }
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
