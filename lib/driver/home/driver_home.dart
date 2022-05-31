import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/driver/home/acceptandrejectride.dart';
import 'package:taxinet_driver/driver/home/bidpage.dart';
import 'package:taxinet_driver/driver/home/pages/rides_tab.dart';
import 'package:taxinet_driver/driver/home/pages/home_tab.dart';
import 'package:taxinet_driver/driver/home/pages/profile_tab.dart';
import 'package:taxinet_driver/driver/home/pages/notifications.dart';
import 'package:http/http.dart' as http;
import '../../controllers/notifications/localnotification_manager.dart';
import '../../states/app_state.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  onTabClicked(int index) {
    setState(() {
      selectedIndex = index;
      _tabController!.index = selectedIndex;
    });
  }

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

  Future<void> getAllTriggeredNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_triggerd_notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      triggeredNotifications = json.decode(jsonData);
      triggered.assignAll(triggeredNotifications);
    }
  }

  Future<void> getAllUnReadNotifications(String token) async {
    const url = "https://taxinetghana.xyz/user_notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){

      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      yourNotifications = json.decode(jsonData);
      notRead.assignAll(yourNotifications);

    }
  }

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
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

  unTriggerNotifications(int id)async{
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "notification_trigger": "Not Triggered",
    });
    if(response.statusCode == 200){

    }
  }
  updateReadNotification(int id)async{
    final requestUrl = "https://taxinetghana.xyz/user_read_notifications/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "read": "Read",
    });
    if(response.statusCode == 200){

    }
  }

  updateDriveBookedStatus(String id,String driver)async{
    final requestUrl = "https://taxinetghana.xyz/update_requested_ride/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    },body: {
      "driver_booked": "True",
      "driver": driver,
    });
    if(response.statusCode == 200){

    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    getAllTriggeredNotifications(uToken);

    final appState = Provider.of<AppState>(context, listen: false);

    appState.getDriversUpdatedLocations(uToken);
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      appState.deleteDriversLocations(uToken);
    });
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      appState.sendLocation(uToken);
    });

    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      getAllTriggeredNotifications(uToken);
      getAllUnReadNotifications(uToken);
      for(var i in triggered){
        localNotificationManager.showRideRequests(i['notification_title'],i['notification_message']);
      }
      for(var i in notRead){
        if(i['notification_title'] == "New Ride Request" && i['read'] == "Not Read"){

          Get.to(() => AcceptAndRejectRide(pickUpLat:i['passengers_lat'],pickUpLng:i['passengers_lng'],dropOffId:i['drop_off_place_id'],dropOff:i['passengers_dropff'],rideDuration:i['ride_duration'],rideDistance:i['ride_distance'],pickUp:i['passengers_pickup'],notificationFrom:i['notification_from'].toString(),notificationTo:i['notification_to'].toString(),rideId:i['ride_id'],passPickUpId:i['pick_up_place_id']));
          updateReadNotification(i['id']);
          updateDriveBookedStatus(i['ride_id'].toString(),i['notification_to'].toString());
        }
        // if(i['notification_title'] == "New bid on price" && i['read'] == "Not Read"){
        //   Get.to(() => BidPrice(rideId: i['ride_id']));
        //   updateReadNotification(i['id']);
        //   // updateDriveBookedStatus(i['ride_id']);
        // }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      for(var e in triggered){
        unTriggerNotifications(e["id"]);
      }
    });

    localNotificationManager.setOnRideRequestNotificationReceive(onRideRequestNotification);
    localNotificationManager.setOnRideRequestNotificationClick(onRideRequestNotificationClick);
  }

  onRideRequestNotification(ReceiveNotification notification){

  }

  onRideRequestNotificationClick(String payload){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomePage(),
                Rides(),
                Notifications(),
                ProfilePage()
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_sharp), label: "Rides"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showSelectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onTabClicked,
      ),
    );
  }
}
