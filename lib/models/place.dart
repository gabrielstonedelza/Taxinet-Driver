import 'package:taxinet_driver/models/geometry.dart';

class Places{
  late final Geometry geometry;
  late String name;
  late String vicinity;

  Places({required this.geometry,required this.name,required this.vicinity});

  factory Places.fromJson(Map<String,dynamic> parseJson){
    return Places(
        geometry: Geometry.fromJson(parseJson['geometry']),
        name: parseJson['formatted_address'],
        vicinity: parseJson['vicinity']
    );
  }
}