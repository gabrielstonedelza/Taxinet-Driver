import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxinet_driver/controllers/services/geolocator_services.dart';

class ApplicationBloc with ChangeNotifier{
  final geoLocatorService = GeoLocatorService();
//  variables

  late Position currentLocation;

  ApplicationBloc(){
    setCurrentLocation();
  }

  setCurrentLocation() async{
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}