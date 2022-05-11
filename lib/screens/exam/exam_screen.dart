// ignore_for_file: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/main.dart';
import 'package:examap/repositories/current_student.dart';
import 'package:examap/widgets/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

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
  TextEditingController textarea = TextEditingController();
  TextEditingController textarea2 = TextEditingController();

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

  CollectionReference location =
      FirebaseFirestore.instance.collection("students");

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
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 204, 202, 202),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: _build(),
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
        const SizedBox(width: 2),
        buildTimeCard(time: minutes),
        const SizedBox(width: 2),
        buildTimeCard(time: seconds),
      ],
    );
  }

  Widget buildTimeCard({required String time}) => Column(
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

  int _index = 0;
  Widget _build() {
    return Stepper(
      controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
        return Row(
          children: <Widget>[
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
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
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
                _choiceBuild()
              ],
            ),
          ),
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
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int? _value = 1;
  Widget _choiceBuild() {
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
