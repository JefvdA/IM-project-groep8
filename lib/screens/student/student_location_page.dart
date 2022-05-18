import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:http/http.dart' as http;

class StudentLocationScreen extends StatelessWidget {
  const StudentLocationScreen(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  Future<String> address() async {
    var response = await http.get(Uri.parse(
        "http://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}&zoom=18&addressdetails="));
    var displayname = json.decode(response.body)["display_name"];
    return displayname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ExamAp")),
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: FlutterMap(
          options:
              MapOptions(center: ll.LatLng(latitude, longitude), minZoom: 10.0),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: ll.LatLng(latitude, longitude),
                  builder: (context) => Container(
                    child: IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
