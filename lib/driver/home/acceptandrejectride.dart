import 'dart:async';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet_driver/driver/home/bidpage.dart';
import 'package:taxinet_driver/driver/home/d_home.dart';

import '../../constants/app_colors.dart';
import '../../states/app_state.dart';
import 'fab_widget.dart';

class AcceptAndRejectRide extends StatefulWidget {
  String rideId;
  String dropOffId;
  String dropOff;
  String pickUpLat;
  String pickUpLng;
  String notificationFrom;
  String passengersUsername;
  String notificationFromPic;
  String pickUp;
  String notificationTo;
  String passengersPickUpId;
  String drop_off_lat;
  String drop_off_lng;

  AcceptAndRejectRide({Key? key,required this.rideId,required this.dropOffId,required this.dropOff,required this.pickUpLat,required this.pickUpLng,required this.notificationFrom,required this.passengersUsername,required this.notificationFromPic,required this.pickUp,required this.notificationTo,required this.passengersPickUpId,required this.drop_off_lat,required this.drop_off_lng}) : super(key: key);

  @override
  State<AcceptAndRejectRide> createState() => _AcceptAndRejectRideState(rideId: this.rideId,dropOffId:this.dropOffId,dropOff:this.dropOff ,pickUpLat:this.pickUpLat,pickUpLng:this.pickUpLng,notificationFrom: this.notificationFrom,passengersUsername: this.passengersUsername,notificationFromPic:this.notificationFromPic,pickUp:this.pickUp,notificationTo:this.notificationTo,passengersPickUpId:this.passengersPickUpId,drop_off_lat: this.drop_off_lat,drop_off_lng: this.drop_off_lng);
}

class _AcceptAndRejectRideState extends State<AcceptAndRejectRide> {
  String rideId;
  String dropOffId;
  String dropOff;
  String pickUpLat;
  String pickUpLng;
  String notificationFrom;
  String passengersUsername;
  String notificationFromPic;
  String pickUp;
  String notificationTo;
  String passengersPickUpId;
  String drop_off_lat;
  String drop_off_lng;
  _AcceptAndRejectRideState({required this.rideId,required this.dropOffId,required this.dropOff,required this.pickUpLat,required this.pickUpLng,required this.notificationFrom,required this.passengersUsername,required this.notificationFromPic,required this.pickUp,required this.notificationTo,required this.passengersPickUpId,required this.drop_off_lat,required this.drop_off_lng});

  var uToken;
  final storage = GetStorage();
  var username = "";
  bool isLoading = true;

  final Completer<GoogleMapController> _mapController = Completer();
  final deMapController = DeMapController.to;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];

  addToRejectedRides() async {
    const bidUrl = "https://taxinetghana.xyz/add_to_rejected_rides/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "driver": notificationTo
    });
    if (response.statusCode == 201) {
    } else {}
  }

  addToAcceptedRides() async {
    const bidUrl = "https://taxinetghana.xyz/add_to_accepted_rides/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "driver": notificationTo,
      "passengers_lat":pickUpLat,
      "passengers_lng":pickUpLng
    });
    if (response.statusCode == 201) {
    } else {}
  }

  void setCustomMarkerIcon()async{
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/location-pin 2.png").then((icon){
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/location-pin_1.png",).then((icon){
      destinationIcon = icon;
    });
  }
  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCVohvMiszUGO-kXyXVAPA2S7eiG890K4I",
      PointLatLng(double.parse(pickUpLat), double.parse(pickUpLng)),
      PointLatLng(double.parse(drop_off_lat), double.parse(drop_off_lng)),
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
    setCustomMarkerIcon();
    getPolyPoints();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    final appState = Provider.of<AppState>(context, listen: false);
    // appState.sendRequest(dropOff);
    appState.sendPassengerRouteRequest(dropOff,LatLng(double.parse(pickUpLat), double.parse(pickUpLng)));
    appState.setSelectedLocation(dropOffId);

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
        body:
        SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Consumer<AppState>(builder: (context,appState,child){
                    return
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: appState.initialPosition, zoom:11.5),
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          trafficEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                            controller.setMapStyle(Utils.mapStyle);
                          },
                          // myLocationEnabled: true,
                          compassEnabled: true,
                          markers:{
                            Marker(
                              markerId: const MarkerId("Source"),
                              position: LatLng(double.parse(pickUpLat), double.parse(pickUpLng)),
                              icon: sourceIcon,
                            ),
                            Marker(
                                markerId: const MarkerId("Destination"),
                                position: LatLng(double.parse(drop_off_lat), double.parse(drop_off_lng)),
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
                      );
                  },),
                  Positioned(
                    height: 300,
                      left: 15,
                      right: 15,
                      bottom: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Card(
                          color: Colors.grey.shade50,
                          elevation: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(notificationFromPic),
                                            radius: 30,
                                          ),
                                        ),
                                        Text("${passengersUsername.toString().capitalize}",style: const TextStyle(fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    Consumer<AppState>(builder: (context,appState,child){
                                      return Text(appState.deTime,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.grey));
                                    },)
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                const Divider(),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Image.asset("assets/images/rec.png",width: 15,height: 15,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(pickUp),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("assets/images/vertical-ellipsis.png",width: 15,height: 15,color: Colors.grey,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Image.asset("assets/images/rec-2.png",width: 15,height: 15,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0),
                                        child: Text(dropOff),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const Divider(),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            addToAcceptedRides();
                                            Get.to(()=> BidPrice(rideId:rideId,driver:notificationTo, pickUp: pickUp,passPickUpId: passengersPickUpId,passengersLat:pickUpLat,passengersLng:pickUpLng,passenger:passengersUsername,drop_off_lat:drop_off_lat,
                                              drop_off_lng:drop_off_lng,));
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          elevation: 8,
                                          child: const Padding(
                                            padding:
                                            EdgeInsets.all(8.0),
                                            child: Text(
                                              "Accept",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                  defaultTextColor1),
                                            ),
                                          ),
                                          fillColor: primaryColor,
                                          splashColor: defaultColor,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "Confirm Cancel",
                                              middleText: "Are you sure you want to cancel ride?",
                                              barrierDismissible: false,
                                              cancel: RawMaterialButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12)),
                                                elevation: 8,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: defaultTextColor1),
                                                  ),
                                                ),
                                                fillColor: Colors.red,
                                                splashColor: defaultColor,
                                              ),
                                              confirm: RawMaterialButton(
                                                onPressed: () {
                                                  appState.driverAcceptRideAndUpdateStatus(uToken, rideId,notificationTo);
                                                  addToRejectedRides();
                                                  appState.polyLines.clear();
                                                  appState.markers.clear();
                                                  Get.offAll(() => const NewDriverHome());
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12)),
                                                elevation: 8,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: defaultTextColor1),
                                                  ),
                                                ),
                                                fillColor: primaryColor,
                                                splashColor: defaultColor,
                                              ),
                                            );
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  12)),
                                          elevation: 8,
                                          child: const Padding(
                                            padding:
                                            EdgeInsets.all(8.0),
                                            child: Text(
                                              "Decline",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 15,
                                                  color:
                                                  defaultTextColor1),
                                            ),
                                          ),
                                          fillColor: Colors.red,
                                          splashColor: defaultColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],

                            ),
                          ),
                        ),
                      )
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
  Future<void> centerScreen(Position position)async{
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom:11.5,bearing: position.heading )));
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
