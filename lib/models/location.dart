class Location{
  final double lat;
  final double lng;

  Location({required this.lat,required this.lng});

  factory Location.fromJson(Map<dynamic,dynamic> parseJson){
    return Location(lat: parseJson['lat'], lng: parseJson['lng']);
  }
}