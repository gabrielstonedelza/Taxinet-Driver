import 'dart:async';
import 'dart:convert';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/constants/app_colors.dart';
import 'package:taxinet_driver/driver/home/fab_widget.dart';
import 'package:get/get.dart';
import '../../controllers/notifications/localnotification_manager.dart';
import '../../states/app_state.dart';
import 'package:http/http.dart' as http;
import 'acceptandrejectride.dart';

class NewDriverHome extends StatefulWidget {
  const NewDriverHome({Key? key}) : super(key: key);

  @override
  State<NewDriverHome> createState() => _NewDriverHomeState();
}

class _NewDriverHomeState extends State<NewDriverHome> {
  final Completer<GoogleMapController> _mapController = Completer();
  final deMapController = DeMapController.to;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;
  late List triggeredNotifications = [];
  late List triggered = [];
  late List yourNotifications = [];
  late List notRead = [];
  late List allNotifications = [];
  late List allNots = [];
  bool isLoading = true;
  bool isRead = true;
  bool status = false;

  Future<void> getAllTriggeredNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      triggeredNotifications = json.decode(jsonData);
      triggered.assignAll(triggeredNotifications);
    }
  }

  Future<void> getAllUnReadNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      yourNotifications = json.decode(jsonData);
      notRead.assignAll(yourNotifications);
    }
  }

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      allNots.assignAll(allNotifications);
    }
    setState(() {
      isLoading = false;
      allNotifications = allNotifications;
    });
  }

  unTriggerNotifications(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "notification_trigger": "Not Triggered",
    });
    if (response.statusCode == 200) {}
  }

  updateReadNotification(int id) async {
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "read": "Read",
    });
    if (response.statusCode == 200) {}
  }

  updateDriveBookedStatus(String id, String driver) async {
    final requestUrl = "https://taxinetghana.xyz/update_requested_ride/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "driver_booked": "True",
      "driver": driver,
    });
    if (response.statusCode == 200) {}
  }
  void setCustomMarkerIcon() async{
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/cab_for_map.png").then((icon){
      sourceIcon = icon;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deMapController.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    setCustomMarkerIcon();

    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    getAllTriggeredNotifications(uToken);

    final appState = Provider.of<AppState>(context, listen: false);
    setState(() {
      status = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      appState.deleteDriversLocations(uToken);
      // Get.snackbar("Delete Alert", "Location is being updated",backgroundColor: Colors.red);
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if(status){
        appState.sendLocation(uToken);
      }
      // Get.snackbar("Addition Alert", "Location is being updated",backgroundColor: Colors.yellow);
    });


    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getAllTriggeredNotifications(uToken);
      getAllUnReadNotifications(uToken);
      for (var i in triggered) {
        localNotificationManager.showRideRequests(
            i['notification_title'], i['notification_message']);
      }
      for (var i in notRead) {
        if (i['notification_title'] == "New Ride Request" &&
            i['read'] == "Not Read") {
          Get.to(() => AcceptAndRejectRide(
            rideId: i['ride_id'],
            dropOffId:i['drop_off_place_id'],
            dropOff: i['passengers_dropOff'],
            pickUpLat: i['passengers_lat'],
            pickUpLng: i['passengers_lng'],
            notificationFrom: i['notification_from'].toString(),
            notificationFromPic:i['get_notification_from_profile_pic'],
            pickUp:i['passengers_pickup'],
            notificationTo:i['notification_to'].toString(),
            passengersPickUpId:i['pick_up_place_id'],
            passengersUsername:i['passengers_username'],
            drop_off_lat:i['drop_off_lat'],
            drop_off_lng:i['drop_off_lng'],
          ));
          updateReadNotification(i['id']);
          updateDriveBookedStatus(
              i['ride_id'].toString(), i['notification_to'].toString());
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      for (var e in triggered) {
        unTriggerNotifications(e["id"]);
      }
    });

    localNotificationManager
        .setOnRideRequestNotificationReceive(onRideRequestNotification);
    localNotificationManager
        .setOnRideRequestNotificationClick(onRideRequestNotificationClick);
  }
  onRideRequestNotification(ReceiveNotification notification) {}

  onRideRequestNotificationClick(String payload) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Consumer<AppState>(builder:(context,appState,child){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        initialCameraPosition:
                        CameraPosition(target: appState.initialPosition, zoom: 15),
                        myLocationButtonEnabled: false,
                        trafficEnabled: true,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller){
                          _mapController.complete(controller);
                          controller.setMapStyle(Utils.mapStyle);
                        },
                        // myLocationEnabled: true,
                        compassEnabled: true,
                        markers: {
                          Marker(
                            markerId: const MarkerId("Source"),
                            position: appState.initialPosition,
                            icon: sourceIcon,
                          ),
                        },
                        onCameraMove: appState.onCameraMove,
                      ),
                    );
                  }),
                  Positioned(
                    top: 20,
                    left: 20,
                    // right: 10,
                    child: FlutterSwitch(
                      activeText: "ONLINE",
                      inactiveText: "OFFLINE",
                      activeColor: Colors.green,
                      inactiveColor: Colors.red,
                      width: 140.0,
                      height: 50.0,
                      valueFontSize: 18.0,
                      toggleSize: 40.0,
                      value: status,
                      borderRadius: 30.0,
                      padding: 8.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          status = val;
                          if(status){
                            Get.snackbar("Hurray 😀,", "you are online",backgroundColor: Colors.green,colorText: defaultTextColor1,snackPosition: SnackPosition.BOTTOM);
                          }
                          else{
                            Get.snackbar("Ohh 😢,", "you are online",backgroundColor: Colors.red,colorText: defaultTextColor1,snackPosition: SnackPosition.BOTTOM);
                          }
                        });
                      },
                    ),
                  ),
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
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 15,bearing: position.heading )));
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