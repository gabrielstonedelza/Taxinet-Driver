import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/driver/home/routetopassenger.dart';

import '../../constants/app_colors.dart';
import '../../states/app_state.dart';
import 'driver_home.dart';

class BidPrice extends StatefulWidget {
  String rideId;
  String driver;
  String pickUp;
  String passPickUpId;
  String passengersLat;
  String passengersLng;
  BidPrice({Key? key, required this.rideId, required this.driver,required this.pickUp, required this.passPickUpId, required this.passengersLat,required this.passengersLng})
      : super(key: key);

  @override
  State<BidPrice> createState() =>
      _BidPriceState(rideId: this.rideId, driver: this.driver, pickUp:this.pickUp, passPickUpId:this.passPickUpId,passengersLat:this.passengersLat,passengersLng:this.passengersLng);
}

class _BidPriceState extends State<BidPrice> {
  String rideId;
  String driver;
  String pickUp;
  String passPickUpId;
  String passengersLat;
  String passengersLng;
  _BidPriceState({required this.rideId, required this.driver,required this.pickUp, required this.passPickUpId,required this.passengersLat, required this.passengersLng});
  var uToken = "";
  final storage = GetStorage();
  var username = "";
  late Timer _timer;
  late final TextEditingController _priceController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var items;

  bidPrice() async {
    final bidUrl = "https://taxinetghana.xyz/bid_ride/$rideId/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "bid": _priceController.text,
    });
    if (response.statusCode == 201) {
    } else {}
  }

  driverAcceptRideAndUpdateStatus(String rideId, String driver, double price) async {
    final requestUrl =
        "https://taxinetghana.xyz/update_requested_ride/$rideId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "driver": driver,
      "ride_accepted": "True",
      "driver_booked": "True",
      "price": price.toString(),
    });
    if (response.statusCode == 200) {}
  }

  addToRejectedRides() async {
    const bidUrl = "https://taxinetghana.xyz/add_to_rejected_rides/";
    final myLink = Uri.parse(bidUrl);
    http.Response response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      "ride": rideId,
      "driver": driver,
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
    final appState = Provider.of<AppState>(context, listen: false);
    appState.getBids(rideId, uToken);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      appState.getBids(rideId, uToken);
    });
    // print(appState.initialPosition);
    // print(pickUp);
    // print(LatLng(appState.lat, appState.lng));
    // print(LatLng(double.parse(passengersLat), double.parse(passengersLng)));
    // if(LatLng(appState.lat, appState.lng) == LatLng(double.parse(passengersLat),double.parse(passengersLng))){
    //   print("You have reached your destination");
    // }
    // print(appState.lat);
    // print(appState.lng);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Bid Price"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RichText(
                text: const TextSpan(
                    text:
                        "Please don't leave this page until the bidding is finalised by you and the passenger",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: defaultTextColor2))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                cursorColor: defaultTextColor2,
                cursorRadius: const Radius.elliptical(10, 10),
                cursorWidth: 5,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_priceController.text == "") {
                          Get.snackbar("Sorry", "price field cannot be empty",
                              snackPosition: SnackPosition.TOP,
                              colorText: defaultTextColor1,
                              backgroundColor: Colors.red);
                        } else {
                          bidPrice();
                          _priceController.text = "";
                        }
                      },
                    ),
                    hintText: "Enter price",
                    hintStyle: const TextStyle(
                      color: defaultTextColor2,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 500,
                child:ListView.builder(
                        itemCount: appState.allBids != null
                            ? appState.allBids.length
                            : 0,
                        itemBuilder: (context, index) {
                          items = appState.allBids[index];

                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Card(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  "${items['username']}'s bid")),
                                          Expanded(
                                            child: items['bid_message'] != null
                                                ? Text(items['bid_message'])
                                                : const Text(""),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            items['bid'],
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: RawMaterialButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Confirm Bid",
                        middleText: "Are you sure you want to accept bid",

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
                            driverAcceptRideAndUpdateStatus(rideId, driver,
                                double.parse(appState.allBids.last['bid']));
                            appState.polyLines.clear();
                            appState.markers.clear();
                            Get.offAll(()=> RouteToPassenger(pickUp: pickUp, passPickUpId: passPickUpId));
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
                      // driverAcceptRideAndUpdateStatus(rideId,driver,double.parse(appState.allBids.last['bid']));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: defaultTextColor1),
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
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
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
                            appState.driverAcceptRideAndUpdateStatus(uToken, rideId,driver);
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
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Reject",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: defaultTextColor1),
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
    );
  }
}
