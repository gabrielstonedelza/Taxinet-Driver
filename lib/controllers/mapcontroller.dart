import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController{
  late double userLatitude = 0.0;
  late double userLongitude = 0.0;
  late StreamSubscription<Position> streamSubscription;
  late String myLocationName = "";
  late String dPlaceId = "";
  bool isLoading = true;
  String apiKey = "AIzaSyCJGvy6wsW0rAOIPjMlSw7xxwMzkvTv7Zw";
  String pickUpLocation = "";
  String dropOffLocation = "";

  void setPickUpLocation(String pickup){
    pickUpLocation = pickup;
    update();
  }
  void setDropOffLocation(String dropOff){
    dropOffLocation = dropOff;
    update();
  }

  //
  late String administrativeArea = '';
  late String locality = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserLocation();
  }


  Future<Object> getUserLocation() async {

    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return getCurrentLocation();
  }

  Stream<Position> getCurrentLocation(){
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Taxinet will still continue to receive your location even in the background",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      );
    }
    else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
    }
    streamSubscription = Geolocator.getPositionStream().listen((Position position) {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
    userLocation();

    return Geolocator.getPositionStream(
        locationSettings: locationSettings
    );
  }

  Future<void> userLocation() async {
    try {
      isLoading = true;
      update();
      if(userLongitude != 0.0 && userLongitude != 0.0){
        List<Placemark> placemark = await placemarkFromCoordinates(userLatitude, userLongitude);

        myLocationName = placemark[2].street!;
        administrativeArea = placemark[2].administrativeArea!;
        locality = placemark[2].locality!;
      }
    } finally {
      isLoading = false;
      update();
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    streamSubscription.cancel();
  }

}