import 'dart:async';
import 'dart:math';
import 'package:taxinet_driver/driver/home/privatechat.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../../controllers/schedulescontroller.dart';
import '../../sendsms.dart';
import '../../widgets/shimmers/shimmerwidget.dart';
import '../newchat.dart';

enum PaymentMethodEnum { wallet, cash }

class ScheduleDetail extends StatefulWidget {
  String slug;
  String id;
  ScheduleDetail({Key? key, required this.slug, required this.id})
      : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState(
        slug: this.slug,
        id: this.id,
      );
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  String slug;
  String id;
  _ScheduleDetailState({required this.slug, required this.id});
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  bool hasOTP = false;
  bool sentOTP = false;
  late int oTP = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController referralController = TextEditingController();
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  generate5digit() {
    var rng = Random();
    var rand = rng.nextInt(90000) + 10000;
    oTP = rand.toInt();
  }

  bool isPosting = false;
  bool isStartingTrip = false;
  bool isEndingTrip = false;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  late final TextEditingController _priceController = TextEditingController();
  List paymentMethods = ["Select payment method", "Wallet", "Cash"];
  String _currentSelectedPaymentMethod = "Select payment method";

  _callNumber(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  ScheduleController controller = Get.find();
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  void _startingTrip() async {
    setState(() {
      isStartingTrip = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isStartingTrip = false;
    });
  }

  void _endingTrip() async {
    setState(() {
      isEndingTrip = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isEndingTrip = false;
    });
  }

  bool tripStarted = false;

  Duration duration = const Duration();
  static const initialTimer = Duration(hours: 00, minutes: 00, seconds: 00);
  Timer? timer;
  String hours = "";
  String minutes = "";
  String seconds = "";

  String myHours = "";
  String myMinutes = "";
  String mySeconds = "";
  String timeElapsed = "";

  bool isLoading = true;
  String passengerId = "";
  String passengerWithSchedule = "";
  String passengerPic = "";
  String passengerPhoneNumber = "";
  String scheduleType = "";
  String rideType = "";
  String pickUpLocation = "";
  String dropOffLocation = "";
  String pickUpTime = "";
  String startDate = "";
  String status = "";
  String dateRequested = "";
  String timeRequested = "";
  String description = "";
  String price = "";
  String scheduleRideId = "";
  String charge = "";
  bool rideStarted = false;
  String dropOffLat = "";
  String dropOffLng = "";
  String pickUpLat = "";
  String pickUpLng = "";
  String passengerUsername = "";
  final SendSmsController sendSms = SendSmsController();

  Future<void> getDetailSchedule() async {
    final walletUrl = "https://taxinetghana.xyz/ride_requests/$id/";
    var link = Uri.parse(walletUrl);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);
      passengerWithSchedule = jsonData['get_passenger_name'];
      dropOffLat = jsonData['drop_off_lat'];
      dropOffLng = jsonData['drop_off_lng'];
      pickUpLat = jsonData['pickup_lat'];
      pickUpLng = jsonData['pickup_lng'];
      scheduleType = jsonData['schedule_type'];
      rideType = jsonData['ride_type'];
      pickUpLocation = jsonData['pickup_location'];
      dropOffLocation = jsonData['drop_off_location'];
      pickUpTime = jsonData['pick_up_time'];
      startDate = jsonData['start_date'];
      status = jsonData['status'];
      dateRequested = jsonData['date_scheduled'];
      timeRequested = jsonData['time_scheduled'];
      price = jsonData['price'];
      charge = jsonData['charge'];
      passengerId = jsonData['passenger'].toString();
      passengerUsername = jsonData['passenger_username'];
      passengerPhoneNumber = jsonData['get_passenger_number'];
      scheduleRideId = jsonData['id'].toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> openMap(String lat,String lng)async {
    // final Uri _url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$drop_off_lat,$drop_off_lng');
    String googleMapUrl = 'https://www.google.com/maps/search/?api=1&query=$dropOffLat,$dropOffLng';
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    }
    else{
      throw 'Could not launch $googleMapUrl';
    }
  }

  void _openGoogleMap(String lat,String lng)async{
    await Future.delayed(const Duration(seconds: 4));
    openMap(lat,lng);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generate5digit();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status){
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(()=> this.hasInternet = hasInternet);
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getDetailSchedule();
  }

  void addTimer() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTimer());
  }

  void reset() {
    setState(() {
      duration = initialTimer;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(id, style: const TextStyle(color: defaultTextColor2)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                tripStarted ?
                  Get.snackbar("Sorry", "Please end trip before leaving this screen",
                      colorText: defaultTextColor1,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds:5),
                      backgroundColor: Colors.red) : Get.back();

              },
              icon: const Icon(Icons.arrow_back, color: defaultTextColor2)),
          actions: [
            scheduleType == "Short Trip" ? Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: IconButton(
                onPressed: (){
                  // Get.to(()=> PrivateChat(passengerUsername:passengerUsername,receiverId:passengerId));
                  Get.to(()=> NewChat(receiverUsername:passengerUsername,receiverId:passengerId,receiverPhone:passengerPhoneNumber,rideId:id,passenger:passengerId));
                },
                icon: Image.asset("assets/images/chat.png",width:40,height:40)
              ),
            ) : Container(),
            TextButton(
              onPressed: (){
                _openGoogleMap(pickUpLat, pickUpLng);
              },
              child: const Text("To Passenger")
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                backgroundColor: primaryColor,
              ))
            : ListView(
                children: [
                  const SizedBox(height: 10),
                  isEndingTrip
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const Center(
                                      child: Text("Complete form and end trip",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          items: paymentMethods
                                              .map((dropDownStringItem) {
                                            return DropdownMenuItem(
                                              value: dropDownStringItem,
                                              child: Text(dropDownStringItem),
                                            );
                                          }).toList(),
                                          onChanged: (newValueSelected) {
                                            _onDropDownItemSelectedMethod(
                                                newValueSelected);
                                          },
                                          value: _currentSelectedPaymentMethod,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: TextFormField(
                                      controller: price == "" ? _priceController : _priceController..text = price,
                                      // cursorColor:
                                      // primaryColor,
                                      cursorRadius:
                                          const Radius.elliptical(3, 3),
                                      cursorWidth: 10,
                                      decoration: const InputDecoration(
                                        labelText: "Enter amount",
                                        labelStyle:
                                            TextStyle(color: secondaryColor),
                                        focusColor: primaryColor,
                                        fillColor: primaryColor,
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter amount";
                                        }
                                      },
                                    ),
                                  ),
                                  isPosting
                                      ? const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(
                                          strokeWidth: 5,
                                          backgroundColor: primaryColor,
                                        ))
                                      : RawMaterialButton(
                                          onPressed: () {
                                            _startPosting();
                                            if (_priceController.text == "" ||
                                                _currentSelectedPaymentMethod ==
                                                    "Select payment method") {
                                              Get.snackbar("Field Error",
                                                  "all fields are required.",
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: defaultTextColor1);
                                            } else {
                                              _endingTrip();
                                              setState(() {
                                                isEndingTrip = true;
                                              });
                                              controller.driverEndTrip(
                                                  passengerId,
                                                  id,
                                                  _priceController.text.trim(),
                                                  _currentSelectedPaymentMethod,
                                                  timeElapsed);
                                              if (scheduleType ==
                                                  "Short Trip") {
                                                controller.updateRide(
                                                    passengerId, id);
                                              }
                                              // Get.back();
                                              setState(() {
                                                _priceController.text = "";
                                                _currentSelectedPaymentMethod =
                                                    "Select payment method";
                                              });
                                            }
                                          },
                                          // child: const Text("Send"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          elevation: 8,
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Save & End Trip",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: defaultTextColor1),
                                            ),
                                          ),
                                          fillColor: primaryColor,
                                          splashColor: defaultColor,
                                        ),
                                ],
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // const Text("Passenger",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                              // const SizedBox(width:10),
                                              buildTime(),
                                              controller.rideStarted
                                                  ? isEndingTrip
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator
                                                                  .adaptive(
                                                          strokeWidth: 5,
                                                          backgroundColor:
                                                              primaryColor,
                                                        ))
                                                      : RawMaterialButton(
                                                          onPressed: () {
                                                            // _endingTrip();
                                                            setState(() {
                                                              isEndingTrip =
                                                                  true;
                                                              tripStarted =
                                                                  false;
                                                              timer?.cancel();
                                                              reset();
                                                            });
                                                          },
                                                          // child: const Text("Send"),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          elevation: 8,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "End Trip",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color:
                                                                      defaultTextColor1),
                                                            ),
                                                          ),
                                                          fillColor: Colors.red,
                                                          splashColor:
                                                              defaultColor,
                                                        )
                                                  : isStartingTrip
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator
                                                                  .adaptive(
                                                          strokeWidth: 5,
                                                          backgroundColor:
                                                              primaryColor,
                                                        ))
                                                      : RawMaterialButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              sentOTP = true;
                                                              String telnum = passengerPhoneNumber;
                                                              telnum = telnum.replaceFirst("0", '+233');
                                                              sendSms.sendMySms(telnum, "Taxinet",
                                                                  "Your code $oTP");
                                                            });
                                                          },
                                                          // child: const Text("Send"),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          elevation: 8,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Start Trip",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color:
                                                                      defaultTextColor1),
                                                            ),
                                                          ),
                                                          fillColor:
                                                              primaryColor,
                                                          splashColor:
                                                              defaultColor,
                                                        ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // passenger profile pic,name and alert arrival button
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [

                                                  passengerWithSchedule == ""
                                                      ? const ShimmerWidget
                                                              .rectangular(
                                                          height: 20)
                                                      : Text(
                                                          "${passengerWithSchedule.toString().capitalize}",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                ],
                                              ),
                                              const SizedBox(width: 20),
                                              isPosting
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive(
                                                      strokeWidth: 5,
                                                      backgroundColor:
                                                          primaryColor,
                                                    ))
                                                  : RawMaterialButton(
                                                      onPressed: () {
                                                        showMaterialModalBottomSheet(
                                                          context: context,
                                                          // expand: true,
                                                          isDismissible: true,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              25.0))),
                                                          bounce: true,
                                                          builder: (context) =>
                                                              Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child: SizedBox(
                                                                height: 300,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            30),
                                                                    const Center(
                                                                        child: Text(
                                                                            "Alert passenger of your arrival by",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold))),
                                                                    const SizedBox(
                                                                        height:
                                                                            30),
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child: GestureDetector(
                                                                                child: Column(
                                                                                  children: const [
                                                                                    Icon(FontAwesomeIcons.bell, size: 30),
                                                                                    SizedBox(height: 20),
                                                                                    Text("Notification", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                                                                                  ],
                                                                                ),
                                                                                onTap: () {
                                                                                  _startPosting();
                                                                                  setState(() {
                                                                                    isPosting = true;
                                                                                  });
                                                                                  controller.driverAlertPassenger(passengerId);
                                                                                  Navigator.pop(context);
                                                                                }),
                                                                          ),
                                                                          Expanded(
                                                                            child: GestureDetector(
                                                                                child: Column(
                                                                                  children: const [
                                                                                    Icon(Icons.phone, size: 30),
                                                                                    SizedBox(height: 20),
                                                                                    Text("Phone Call", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                                                                                  ],
                                                                                ),
                                                                                onTap: () {
                                                                                  // dial(controller.passengerPhoneNumber);
                                                                                  _callNumber(passengerPhoneNumber);
                                                                                }),
                                                                          ),
                                                                        ])
                                                                  ],
                                                                )),
                                                          ),
                                                        );
                                                      },
                                                      // child: const Text("Send"),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      elevation: 8,
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Alert Passenger",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                              color:
                                                                  defaultTextColor1),
                                                        ),
                                                      ),
                                                      fillColor: Colors.green,
                                                      splashColor: defaultColor,
                                                    )
                                            ],
                                          )
                                        ]),
                                    const SizedBox(height: 10),
                                    const Divider(),
                                    const SizedBox(height: 10),
                                 sentOTP ?  Column(
                                   children: [
                                     const SizedBox(height: 10,),
                                     const Text("A message with your OTP has been sent to the number provider"),
                                     const SizedBox(height: 10,),
                                     GestureDetector(
                                         onTap: (){
                                           String telnum = referralController.text;
                                           telnum = telnum.replaceFirst("0", '+233');
                                           sendSms.sendMySms(telnum, "Taxinet",
                                               "Your code $oTP");
                                           Get.snackbar("Success", "OTP was resent",
                                               colorText: defaultTextColor1,
                                               snackPosition: SnackPosition.TOP,
                                               backgroundColor: snackColor);
                                         },
                                         child: const Text("Resend OTP",style: TextStyle(fontWeight: FontWeight.bold,color: defaultTextColor2),)
                                     ),
                                     const SizedBox(height: 20,),
                                     myPinBox(),
                                     const SizedBox(height: 10,),
                                   ],
                                 ):
                                 Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Schedule Type",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              scheduleType == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(scheduleType)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Ride Type",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              rideType == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(rideType)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Pickup Location",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              pickUpLocation == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(pickUpLocation)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Drop Off Location",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              dropOffLocation == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(dropOffLocation)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Pick up time",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              pickUpTime == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(pickUpTime)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Start Date",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              startDate == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(startDate)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Status",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              status == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(status)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Date Requested",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              dateRequested == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(dateRequested)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Time Requested",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              timeRequested == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(timeRequested
                                                      .toString()
                                                      .split(".")
                                                      .first)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Price",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              price == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(price)
                                            ]),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Charge",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              const SizedBox(height: 10),
                                              charge == ""
                                                  ? const ShimmerWidget.rectangular(
                                                      height: 20)
                                                  : Text(charge)
                                            ]),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        )
                ],
              ),
      ),
    );
  }

  void _onDropDownItemSelectedMethod(newValueSelected) {
    setState(() {
      _currentSelectedPaymentMethod = newValueSelected;
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    setState(() {
      hours = twoDigits(duration.inHours);
      minutes = twoDigits(duration.inMinutes.remainder(60));
      seconds = twoDigits(duration.inSeconds.remainder(60));

      myHours = hours.toString();
      myMinutes = minutes.toString();
      mySeconds = seconds.toString();
      timeElapsed = "$myHours:$myMinutes:$mySeconds";
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: "H"),
        const SizedBox(width: 10),
        buildTimeCard(time: minutes, header: "Min"),
        const SizedBox(width: 10),
        buildTimeCard(time: seconds, header: "Sec")
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(time,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget myPinBox(){

    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 68,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin1Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[0]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  autofocus: true,
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),

          ),
          SizedBox(
            height: 68,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin2Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[1]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 68,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin3Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[2]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 68,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin4Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[3]){
                      FocusScope.of(context).nextFocus();
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),

          ),
          SizedBox(
            height: 68,
            width: 60,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[500]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Center(
                child: TextFormField(
                  controller: pin5Controller,
                  onChanged: (value){
                    if(value.length == 1 && value == oTP.toString()[4]){
                      // FocusScope.of(context).nextFocus();
                      setState(() {
                        hasOTP = true;
                        sentOTP = false;
                        isStartingTrip =
                        true;
                        tripStarted =
                        true;
                      });
                      _startingTrip();

                      controller
                          .driverStartTrip(
                              passengerId,
                              id);
                      // //  start timer here
                      startTimer();
                      _openGoogleMap(dropOffLat, dropOffLng);
                      // openMap(drop_off_lat, drop_off_lng);
                    }
                    else{
                      Get.snackbar("Number Error", "invalid number",
                          duration: const Duration(seconds: 5),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: defaultTextColor1);
                    }
                  },
                  style: Theme.of(context).textTheme.headline6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                  // controller: otpController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: defaultTextColor1,),
                  ),
                  cursorColor: defaultTextColor1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
