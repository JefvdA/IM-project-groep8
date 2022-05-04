import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as l;
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  CollectionReference location =
      FirebaseFirestore.instance.collection("students");

  Future<void> addLocation() {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position? position) {
      position == null
          ? 'Unknown'
          : location
              .doc(LoggedIn.sNummer)
              .update({"lat": position.latitude, "lon": position.longitude});
    });
    positionStream;
    return location.doc(LoggedIn.sNummer).get();
  }

  @override
  Widget build(BuildContext context) {
    addLocation();
    return Container(
      child: FutureBuilder<DocumentSnapshot>(
        future: location.doc(LoggedIn.sNummer).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            print('https://www.openstreetmap.org/#map=14/' +
                data['lat'].toString() +
                '/' +
                data['lon'].toString());
            l.MapController controller = l.MapController(
              initMapWithUserPosition: false,
              initPosition:
                  l.GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
            );
            return l.OSMFlutter(
              controller: controller,
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
