

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRequest with ChangeNotifier{
  MapRequest._();
  static MapRequest? _instance;

  static MapRequest? get instance{
    _instance ??= MapRequest._();
    return _instance;
  }
  final String baseUrl = "https://maps.googleapis.com/maps/api/directions/json";
  ValueNotifier<LatLng?>? currentPosition = ValueNotifier<LatLng?>(null);
  ValueNotifier<Set<Marker>> markers = ValueNotifier<Set<Marker>>({});
}