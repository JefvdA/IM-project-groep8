// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/Location.dart';
import 'package:examap/test.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key}) : super(key: key);

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  String user = LoggedIn.sNummer;
  CollectionReference location =
      FirebaseFirestore.instance.collection("students");
      askPermission() async{
        LocationPermission permission = await Geolocator.requestPermission();
        Position position = await Geolocator.getCurrentPosition();
        await location
          .doc(LoggedIn.sNummer)
          .update({"lat": position.latitude, "lon": position.longitude});
      }
  
    
    getLocation() async {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
  Future<void> test() async {
    location
      .doc(LoggedIn.sNummer)
      .update({"lat": 51.456, "lon": 5.485});
  }
  List<String> question = [
    "Wat is het beste framework ?",
    "Wat is de mooiste kleur ?",
    "Leg uit waarom dit de mooiste kleur is ?"
  ];
  @override
  Widget build(BuildContext context) {
    askPermission();
    //test();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user),
            for (var i in question)
              Column(
                children: [Text(i)],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Location()),
                    );
                  },
                  child: const Text("Show Location")),
          ],
        ),
      ),
    );
  }
}
