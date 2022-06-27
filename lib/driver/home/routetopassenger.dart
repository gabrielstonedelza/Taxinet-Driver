import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../states/app_state.dart';
import 'fab_widget.dart';

class RouteToPassenger extends StatefulWidget {
  String pickUp;
  String passPickUpId;
  String pickUpLat;
  String pickUpLng;
  String drop_off_lat;
  String drop_off_lng;

  RouteToPassenger({Key? key,required this.pickUp, required this.passPickUpId,required this.pickUpLat,required this.pickUpLng,required this.drop_off_lat,required this.drop_off_lng}) : super(key: key);

  @override
  State<RouteToPassenger> createState() => _RouteToPassengerState(pickUp:this.pickUp, passPickUpId:this.passPickUpId,pickUpLat:this.pickUpLat,pickUpLng:this.pickUpLng,drop_off_lat:this.drop_off_lat,drop_off_lng:this.drop_off_lng);
}

class _RouteToPassengerState extends State<RouteToPassenger> {
  String pickUp;
  String passPickUpId;
  String pickUpLat;
  String pickUpLng;
  String drop_off_lat;
  String drop_off_lng;
  _RouteToPassengerState({required this.pickUp, required this.passPickUpId,required this.pickUpLat,required this.pickUpLng,required this.drop_off_lat,required this.drop_off_lng});
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];


  final Completer<GoogleMapController> _mapController = Completer();
  final deMapController = DeMapController.to;
  void setCustomMarkerIcon()async{
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/cab_for_map.png").then((icon){
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/location-pin_1.png",).then((icon){
      destinationIcon = icon;
    });
  }
  void getPolyPoints(double driversLat,double driversLng) async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCVohvMiszUGO-kXyXVAPA2S7eiG890K4I",
      PointLatLng(driversLat, driversLng),
      PointLatLng(double.parse(pickUpLat), double.parse(pickUpLng)),
    );

    if(result.points.isNotEmpty){
      for (var point in result.points) {
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      }
      setState(() {});
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    setCustomMarkerIcon();
    getPolyPoints(appState.lat,appState.lng);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });

    appState.sendPassengerRouteRequest(pickUp,LatLng(double.parse(pickUpLat), double.parse(pickUpLng)));
    appState.setSelectedLocation(passPickUpId);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.sendPassengerRouteRequest(pickUp,LatLng(double.parse(pickUpLat), double.parse(pickUpLng)));
      appState.setSelectedLocation(passPickUpId);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(

        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: appState.initialPosition, zoom: 11.5),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            trafficEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              controller.setMapStyle(Utils.mapStyle);
            },
            // myLocationEnabled: true,
            compassEnabled: true,
            markers:{
              Marker(
                markerId: const MarkerId("Source"),
                position: LatLng(appState.lat, appState.lng),
                icon: sourceIcon,
              ),
              Marker(
                  markerId: const MarkerId("Destination"),
                  position: LatLng(double.parse(pickUpLat), double.parse(pickUpLng)),
                  icon: destinationIcon
              ),
            },
            onCameraMove: appState.onCameraMove,
            polylines: {
              Polyline(
                  polylineId:const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.green,
                  width: 5
              ),
            },
          ),
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 11.5,bearing: position.heading )));
  }
}

class Utils {
  static String mapStyle = ''' 
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8ec3b9"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1a3646"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#64779e"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#4b6878"
      }
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#334e87"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6f9ba5"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3C7680"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#304a7d"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2c6675"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#255763"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#b0d5ce"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#023e58"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#98a5be"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1d2c4d"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#283d6a"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3a4762"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#0e1626"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#4e6d70"
      }
    ]
  }
]
  ''';
}