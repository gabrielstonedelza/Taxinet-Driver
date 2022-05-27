import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/constants/app_colors.dart';
import 'package:http/http.dart' as http;
import '../../../states/app_state.dart';
import 'package:get/get.dart';

class RideDetail extends StatefulWidget {
  final id;
  RideDetail({Key? key,this.id}) : super(key: key);

  @override
  State<RideDetail> createState() => _RideDetailState(id:this.id);
}

class _RideDetailState extends State<RideDetail> {
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  final id;
  bool isLoading = true;
  late String passenger = "";
  late String pickUp = "";
  late String dropOff = "";
  late double price = 0.0;
  late String dateRequested = "";
  late String passengerProfilePic = "";


  _RideDetailState({ required this.id});
  Future<void> fetchRideDetail(int id, String uToken) async {
    try {
      isLoading = true;
      final detailRideUrl = "https://taxinetghana.xyz/ride_requests/$id/";
      final myLink = Uri.parse(detailRideUrl);
      http.Response response = await http.get(myLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        print(response.body);
        var jsonData = jsonDecode(response.body);
        passenger = jsonData['passengers_username'];
        pickUp = jsonData['pick_up'];
        dropOff = jsonData['drop_off'];
        price = jsonData['price'];
        dateRequested = jsonData['date_requested'];
        passengerProfilePic = jsonData['get_passenger_profile_pic'];
        print("This is date requested: $dateRequested");
        print("This is passenger: $passenger");
        print("This is date requested: $pickUp");
        print("This is date requested: $dropOff");
        print("This is date requested: $passengerProfilePic");
      }
    } catch (e) {
      Get.snackbar("Sorry", "please check your internet connection");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

    // appState.fetchRideDetail(id,uToken);
    fetchRideDetail(id,uToken);
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Ride Details"),
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: primaryColor,
        ),
      ) :ListView(
        children: [
          const SizedBox(height: 20,),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      passengerProfilePic != null ? CircleAvatar(
                        backgroundImage: NetworkImage(passengerProfilePic),
                        radius: 30,
                      ) : const Icon(Icons.person),
                      const SizedBox(width: 20,),
                      Center(
                        child: Text(passenger.toString().toUpperCase()),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Pick up: "),
                      Text(pickUp),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Drop Off: "),
                      Text(dropOff),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Date: "),
                      Text(dateRequested.toString().split("T").first,style: TextStyle(color: Colors.red),),
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
