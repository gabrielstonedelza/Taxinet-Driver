import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/states/app_state.dart';

import '../../../constants/app_colors.dart';
import 'package:get/get.dart';

import '../acceptandrejectride.dart';
import '../fab_widget.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late String username = "";
  final storage = GetStorage();
  late String uToken = "";
  var items;
  late Timer _timer;
  late List allNotifications = [];
  late List allNots = [];
  bool isLoading = true;

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    if(storage.read("username") != null){
      setState(() {
        username = storage.read("username");
      });
    }
    if(storage.read("userToken") != null){
      setState(() {
        uToken = storage.read("userToken");
      });
    }
    getAllNotifications(uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getAllNotifications(uToken);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          backgroundColor: defaultTextColor2,
        ),
        body: isLoading ? const Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            backgroundColor: primaryColor,
          ),
        ) :ListView.builder(
          itemCount: allNotifications != null ? allNotifications.length :0,
            itemBuilder: (context,index){
            items = allNotifications[index];
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  SlideInUp(
                    animate: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0,right: 18.0),
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 10),
                          child: items['read'] == "Read" ? ListTile(
                            onTap: (){
                              if(items['notification_title'] == "New Ride Request"){
                                Get.to(()=>AcceptAndRejectRide(
                                  rideId: items['ride_id'],
                                  dropOffId:items['drop_off_place_id'],
                                  dropOff: items['passengers_dropff'],
                                  pickUpLat: items['passengers_lat'],
                                  pickUpLng: items['passengers_lng'],
                                  notificationFrom: items['notification_from'].toString(),
                                  passengersUsername: items['passengers_username'],
                                  notificationFromPic:items['get_notification_from_profile_pic'],
                                    pickUp:items['passengers_pickup'],
                                    notificationTo:items['notification_to'].toString(),
                                    passengersPickUpId:items['pick_up_place_id'],
                                  drop_off_lat:items['drop_off_lat'],
                                  drop_off_lng:items['drop_off_lng'],
                                ));
                              }
                            },
                            leading: const CircleAvatar(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.notifications)
                            ),
                            title: Text(items['notification_title'],style: const TextStyle(color: Colors.grey),),
                          ) : ListTile(
                            onTap: (){
                              if(items['notification_title'] == "New Ride Request"){
                                  Get.to(()=>AcceptAndRejectRide(
                                    rideId: items['ride_id'],
                                    dropOffId:items['drop_off_place_id'],
                                    dropOff: items['passengers_dropff'],
                                    pickUpLat: items['passengers_lat'],
                                    pickUpLng: items['passengers_lng'],
                                    notificationFrom: items['notification_from'].toString(),
                                    passengersUsername: items['passengers_username'],
                                    notificationFromPic:items['get_notification_from_profile_pic'],
                                      pickUp:items['passengers_pickup'],
                                      notificationTo:items['notification_to'].toString(),
                                      passengersPickUpId:items['pick_up_place_id'],
                                    drop_off_lat:items['drop_off_lat'],
                                    drop_off_lng:items['drop_off_lng'],
                                  ));
                              }
                            },
                            leading: const CircleAvatar(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.notifications)
                            ),
                            title: Text(items['notification_title'],style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
}
