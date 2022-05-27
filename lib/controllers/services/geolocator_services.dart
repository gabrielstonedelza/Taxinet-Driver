import 'package:geolocator/geolocator.dart';

class GeoLocatorService{

  Future<Position> getCurrentLocation()async{
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,timeLimit: const Duration(seconds: 10));
  }
  
  Future<double> getDistance(double startLat,double startLng,double engLat,double engLng)async{
    return Geolocator.distanceBetween(startLat, startLng, engLat, engLng);
  }
}