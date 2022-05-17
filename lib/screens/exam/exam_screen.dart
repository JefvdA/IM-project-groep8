// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';

import 'package:examap/models/answer/answer.dart';
import 'package:examap/models/answer/impl/oq_answer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:examap/widgets/global_app_bar.dart';
import 'package:examap/main.dart';

import 'package:examap/repositories/current_student.dart';

import 'package:examap/screens/exam/local_widgets/code_correction_question.dart';
import 'package:examap/screens/exam/local_widgets/multiple_choice_question.dart';
import 'package:examap/screens/exam/local_widgets/open_question.dart';

import 'package:flutter/foundation.dart';

import '../../models/answer/impl/cc_answer.dart';
import '../../models/answer/impl/mc_answer.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with WidgetsBindingObserver {
  String user = CurrentStudent.sNummer;
  double latitude = 0;
  double longitude = 0;

  List<Answer> answers = [];

  //timer
  static const countdownDuration = Duration(hours: 3);
  Duration _duration = const Duration();
  bool isCountdown = true;
  Timer? timer;

  int leftApplicationCount = 0;

  int currentStep = 0;
  late List<Step> steps = [];

  List<GlobalKey<FormState>> formKeys = [];

  get headerColor => null;

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference questionsCollection = FirebaseFirestore.instance
      .collection('exams')
      .doc('Intro mobile')
      .collection("questions");

  final CollectionReference restultsCollection =
      FirebaseFirestore.instance.collection('results');

  @override
  void initState() {
    super.initState();

    addSteps();

    WidgetsBinding.instance!.addObserver(this);

    startTimer();
    reset();
  }

  void addSteps() async {
    QuerySnapshot questionsSnapshot = await questionsCollection.get();
    for (int i = 0; i < questionsSnapshot.docs.length; i++) {
      formKeys.add(GlobalKey<FormState>());
      final QueryDocumentSnapshot<Object?> question = questionsSnapshot.docs[i];
      steps.add(
        Step(
          title: Text(
            question.get('question'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Colors.black,
            ),
          ),
          content: Form(
            key: formKeys[i],
            child: _buildQuestion(question),
          ),
        ),
      );
    }
  }

  void goToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        state = AppLifecycleState.resumed;
        if (kDebugMode) {
          print("resumed");
        }
      } else if (state == AppLifecycleState.paused) {
        state = AppLifecycleState.paused;
        setState(() {
          leftApplicationCount += 1;
        });
      }
    });
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
          endExam();
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

  void askPermission() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    latitude = position.latitude;
    longitude = position.longitude;
  }

  void getAnswers() {
    for (int i = 0; i < formKeys.length; i++) {
      final formKey = formKeys[i];
      formKey.currentState?.save();
    }
  }

  void endExam() {
    var totalScore = 0;
    var maxScore = 0;
    var totalQuestions = 0;
    var needGrading = 0;
    // Get data from question forms
    getAnswers();

    // Save results to firestore
    answers.map((e) => jsonDecode(jsonEncode(e)));
    for (var i = 0; i < answers.length; i++) {
      totalQuestions++;
      if (answers[i].type == "OQ") {
        needGrading++;
        maxScore += answers[i].points;
      }
      if (answers[i].type == "MC") {
        var x = answers[i] as MCAnswer;
        totalScore += x.automaticCodeCorrection();
        maxScore += answers[i].points;
      }
      if (answers[i].type == "CC") {
        var x = answers[i] as CCAnswer;
        totalScore += x.automaticCodeCorrection();
        maxScore += answers[i].points;
      }
    }
    restultsCollection.doc(user).set({
      "student": user,
      "score": totalScore,
      "location": {
        "lat": latitude,
        "lon": longitude,
      },
      "maxScore": maxScore,
      "totalQuestions": totalQuestions,
      "needGrading": needGrading,
      "answers": answers.map((e) => jsonDecode(jsonEncode(e))),
      "leftApplicationCount": leftApplicationCount,
    });

    // Remove student from students collection
    studentsCollection.doc(CurrentStudent.sNummer).delete();

    // Return to homescreen
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const MyApp(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (Route<dynamic> route) => false,
    );
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
                        future: questionsCollection.get(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData && steps.isNotEmpty) {
                            return Stepper(
                              steps: steps,
                              currentStep: currentStep,
                              controlsBuilder: (BuildContext context,
                                  ControlsDetails controlsDetails) {
                                return Row(
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'Vorige',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        controlsDetails.onStepCancel!();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Volgende',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        controlsDetails.onStepContinue!();
                                      },
                                    ),
                                  ],
                                );
                              },
                              onStepCancel: () {
                                if (currentStep > 0) {
                                  goToStep(currentStep - 1);
                                }
                              },
                              onStepContinue: () {
                                if (currentStep + 1 != steps.length) {
                                  goToStep(currentStep + 1);
                                }
                              },
                              onStepTapped: (int index) {
                                goToStep(index);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Examen indienen"),
                          content: const Text(
                              "Weet u zeker dat u het examen wilt indienen? U kan niet meer teruggaan."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Annuleren"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                endExam();
                              },
                              child: const Text("Indienen"),
                            ),
                          ],
                        ),
                      ),
                      child: const Text("Examen indienen"),
                    ),
                    Text("Je hebt $leftApplicationCount keer de app verlaten !")
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

  Widget _buildQuestion(QueryDocumentSnapshot<Object?> question) {
    switch (question['type']) {
      case "OQ":
        return OpenQuestion(question, addAnswer);
      case "MC":
        return MultipleChoiceQuestion(question, addAnswer);
      case "CC":
        return CodeCorrectionQuestion(question, addAnswer);
      default:
        return Container();
    }
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
