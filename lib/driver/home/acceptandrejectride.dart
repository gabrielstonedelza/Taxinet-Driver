import 'dart:async';
import 'dart:convert';
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

  AcceptAndRejectRide({Key? key,required this.pickUpLat,required this.pickUp,required this.pickUpLng,required this.dropOffId,required this.dropOff,required this.rideDuration,required this.rideDistance,required this.notificationFrom,required this.notificationTo,required this.rideId}) : super(key: key);

  @override
  State<AcceptAndRejectRide> createState() => _AcceptAndRejectRideState(pickUpLat:this.pickUpLat,pickUp:this.pickUp,pickUpLng:this.pickUpLng,dropOffId:this.dropOffId,dropOff:this.dropOff,rideDuration:this.rideDuration,rideDistance:this.rideDistance,notificationFrom:this.notificationFrom,notificationTo:this.notificationTo,rideId: this.rideId);
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
  var uToken = "";
  final storage = GetStorage();
  var username = "";

  _AcceptAndRejectRideState({required this.pickUpLat,required this.pickUp,required this.pickUpLng, required this.dropOffId,required this.dropOff,required this.rideDuration,required this.rideDistance,required this.notificationFrom,required this.notificationTo,required this.rideId});
  final Completer<GoogleMapController> _mapController = Completer();


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
                      target: LatLng(double.parse(pickUpLat),double.parse(pickUpLng)), zoom: 11.5),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
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
                  color: primaryColor
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
                                Get.to(()=> BidPrice(rideId:rideId,driver:notificationTo));
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

}
