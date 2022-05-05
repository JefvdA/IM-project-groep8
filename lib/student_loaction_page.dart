// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examap/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as l;

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
    CollectionReference location =
      FirebaseFirestore.instance.collection("students");

      setMarker(controller, lat, lon) async {
        await controller.addMarker(l.GeoPoint(latitude: lat, longitude: lon),const l.MarkerIcon(icon: Icon(Icons.abc)));
      }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: location.doc(CurrentUser.sNummer).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          l.MapController controller = l.MapController(
            initMapWithUserPosition: false,
            initPosition:
                l.GeoPoint(latitude: data['lat'], longitude: data['lon']),
          );
          setMarker(controller, data['lat'], data['lon']);
          return l.OSMFlutter(
            controller: controller,
            initZoom: 10,
            userLocationMarker: l.UserLocationMaker(
              personMarker: const l.MarkerIcon(icon: Icon(Icons.person)),
              directionArrowMarker: const l.MarkerIcon(icon: Icon(Icons.arrow_forward)),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
