import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet_driver/driver/home/bidpage.dart';

import '../../constants/app_colors.dart';
import '../../states/app_state.dart';
import 'driver_home.dart';

class AcceptAndRejectRide extends StatefulWidget {
  String pickUpLat;
  String pickUp;
  String pickUpLng;
  String dropOffId;
  String dropOff;
  String rideDuration;
  String rideDistance;
  String notificationFrom;
  String notificationTo;
  String rideId;
  String passPickUpId;

  AcceptAndRejectRide({Key? key,required this.pickUpLat,required this.pickUp,required this.pickUpLng,required this.dropOffId,required this.dropOff,required this.rideDuration,required this.rideDistance,required this.notificationFrom,required this.notificationTo,required this.rideId, required this.passPickUpId}) : super(key: key);

  @override
  State<AcceptAndRejectRide> createState() => _AcceptAndRejectRideState(pickUpLat:this.pickUpLat,pickUp:this.pickUp,pickUpLng:this.pickUpLng,dropOffId:this.dropOffId,dropOff:this.dropOff,rideDuration:this.rideDuration,rideDistance:this.rideDistance,notificationFrom:this.notificationFrom,notificationTo:this.notificationTo,rideId: this.rideId, passPickUpId:this.passPickUpId);
}

class _AcceptAndRejectRideState extends State<AcceptAndRejectRide> {
  String pickUpLat;
  String pickUp;
  String pickUpLng;
  String dropOffId;
  String dropOff;
  String rideDuration;
  String rideDistance;
  String notificationFrom;
  String notificationTo;
  String rideId;
  String passPickUpId;

  var uToken = "";
  final storage = GetStorage();
  var username = "";

  _AcceptAndRejectRideState({required this.pickUpLat,required this.pickUp,required this.pickUpLng, required this.dropOffId,required this.dropOff,required this.rideDuration,required this.rideDistance,required this.notificationFrom,required this.notificationTo,required this.rideId, required this.passPickUpId});
  final Completer<GoogleMapController> _mapController = Completer();
  final deMapController = DeMapController.to;

  addToRejectedRides() async {
    const bidUrl = "https://taxinetghana.xyz/add_to_rejected_rides/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "driver": notificationTo,
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
    });
    if (response.statusCode == 201) {
    } else {}
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    appState.sendRequest(dropOff);
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(pickUpLat),double.parse(pickUpLng)), zoom:11.5),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  trafficEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    controller.setMapStyle(Utils.mapStyle);
                  },
                  myLocationEnabled: true,
                  compassEnabled: true,
                  markers: appState.markers,
                  onCameraMove: appState.onCameraMove,
                  polylines: appState.polyLines,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.grey
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Text(rideDuration,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(rideDistance,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1),),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 18.0),
                            child: Text("Pick Up : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(pickUp,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1),),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 18.0),
                            child: Text("Drop Off : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: Text(dropOff,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: defaultTextColor1),),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                addToAcceptedRides();
                                Get.to(()=> BidPrice(rideId:rideId,driver:notificationTo, pickUp: pickUp,passPickUpId: passPickUpId,passengersLat:pickUpLat,passengersLng:pickUpLng));
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
                                  titleStyle: TextStyle(),
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
                                      Get.offAll(() => const DriverHome());
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
            )
          ],
        ),
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