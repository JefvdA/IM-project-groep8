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

      SetMarker(controller, lat, lon) async {
        await controller.addMarker(l.GeoPoint(latitude: lat, longitude: lon),l.MarkerIcon(icon: Icon(Icons.abc)));
      }

  @override
  Widget build(BuildContext context) {
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
            l.MapController controller = l.MapController(
              initMapWithUserPosition: false,
              initPosition:
                  l.GeoPoint(latitude: data['lat'], longitude: data['lon']),
            );
            SetMarker(controller, data['lat'], data['lon']);
            return l.OSMFlutter(
              controller: controller,
              initZoom: 10,
              userLocationMarker: l.UserLocationMaker(
                personMarker: l.MarkerIcon(icon: Icon(Icons.person)),
                directionArrowMarker: l.MarkerIcon(icon: Icon(Icons.arrow_forward)),
              ),
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
