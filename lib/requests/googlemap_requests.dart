import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const apiKey = "";
final String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";

class GoogleMapsServices{
  Duration duration = Duration();
  Future<String> getRouteCoordinates(LatLng startLatLng,LatLng endLatLng)async{
    var uri = Uri.parse("$baseUrl?origin=${startLatLng.latitude},${startLatLng.longitude}&destination=${endLatLng.latitude},${endLatLng.longitude}&key=$apiKey");

    http.Response response = await http.get(uri);
    Map values = jsonDecode(response.body);
    print(response.body);
    final points = values["routes"][0]["overview_polyline"]["points"];
    final legs = values['routes'][0]['legs'];

    if(legs != null){
      final DateTime time = DateTime.fromMillisecondsSinceEpoch(values['routes'][0]['legs'][0]['duration']['value']);
      duration  = DateTime.now().difference(time);
    }
    return points;
  }
}
