import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/constants/app_colors.dart';
import 'package:taxinet_driver/driver/home/pages/ride_detail.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../states/app_state.dart';
import '../fab_widget.dart';

class Rides extends StatefulWidget {
  const Rides({Key? key}) : super(key: key);

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  bool isLoading = true;
  var items;
  late List driversCompletedRides = [];

  Future<void> getDriversRidesCompleted() async {
    try {
      const completedRides =
          "https://taxinetghana.xyz/drivers_requests_completed";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        driversCompletedRides.assignAll(jsonData);

      } else {
        Get.snackbar("Sorry", "please check your internet connection");
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context,listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getDriversRidesCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Your rides"),
          centerTitle: true,
        ),
        body: isLoading ? const Center(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: primaryColor,
          ),
        ) :ListView.builder(
          itemCount: driversCompletedRides != null ? driversCompletedRides.length : 0,
            itemBuilder: (context,index){
            items = driversCompletedRides[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white54
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(items['get_passenger_profile_pic']),
                                      radius: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text("${items['passengers_username'].toString().capitalize}",style: const TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("GHS ${items['price']}",style: const TextStyle(fontWeight: FontWeight.bold),),
                                    Column(
                                      children: [
                                        Text(items['date_requested'].toString().split("T").first,style: const TextStyle(color: Colors.grey)),
                                        Text(items['time_requested'].toString().split(".").first,style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            const Divider(),
                            const SizedBox(height: 10,),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text("Pick Up",style: TextStyle(color: Colors.grey),),
                            ),
                            Text(items['pick_up'],style: const TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(height: 10,),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text("Drop Off",style: TextStyle(color: Colors.grey),),
                            ),
                            Text(items['drop_off'],style: const TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
}
