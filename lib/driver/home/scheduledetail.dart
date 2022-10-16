
import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_colors.dart';
import "package:get/get.dart";

import '../../controllers/schedulescontroller.dart';
import '../../widgets/shimmers/shimmerwidget.dart';
enum PaymentMethodEnum { wallet, cash }

class ScheduleDetail extends StatefulWidget {
  String slug;
  String title;
  String id;
  ScheduleDetail({Key? key, required this.slug,required this.title,required this.id}) : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState(slug:this.slug,title:this.title,id:this.id,);
}

class _ScheduleDetailState extends State<ScheduleDetail> {
  String slug;
  String title;
  String id;
  _ScheduleDetailState({required this.slug,required this.title,required this.id});
  bool isPosting = false;
  bool isStartingTrip = false;
  bool isEndingTrip = false;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  late final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List paymentMethods = [
    "Select payment method",
    "Wallet",
    "Cash"
  ];
  String _currentSelectedPaymentMethod = "Select payment method";

  _callNumber(String phoneNumber) async{
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
    controller.getDetailSchedule(slug);
  }

  void addTimer(){
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds:1),
        (_)=> addTimer()
    );
  }

  void reset(){
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
            title: Text(title,style:const TextStyle(color: defaultTextColor2)),
            centerTitle: true,
            backgroundColor:Colors.transparent,
            elevation:0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
            ),
          ),
          body: ListView(

            children: [
              const SizedBox(height:10),
              isEndingTrip ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Center(
                            child: Text("Complete form and end trip",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                        ),
                        const SizedBox(height:20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: DropdownButton(

                                isExpanded: true,
                                underline: const SizedBox(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                                items: paymentMethods.map((dropDownStringItem) {
                                  return DropdownMenuItem(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem),
                                  );
                                }).toList(),
                                onChanged: (newValueSelected) {
                                  _onDropDownItemSelectedMethod(newValueSelected);
                                },
                                value: _currentSelectedPaymentMethod,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets
                              .only(
                              bottom:
                              10.0),
                          child:
                          TextFormField(
                            controller:
                            _priceController,
                            // cursorColor:
                            // primaryColor,
                            cursorRadius:
                            const Radius
                                .elliptical(
                                3, 3),
                            cursorWidth: 10,
                            decoration: const InputDecoration(
                              labelText:
                              "Enter amount",
                              labelStyle:
                              TextStyle(
                                  color:
                                  secondaryColor),
                              focusColor:
                              primaryColor,
                              fillColor:
                              primaryColor,

                            ),
                            keyboardType:
                            TextInputType
                                .number,
                            validator:
                                (value) {
                              if (value!
                                  .isEmpty) {
                                return "Please enter amount";
                              }
                            },
                          ),
                        ),
                     isPosting ? const Center(
                       child: CircularProgressIndicator.adaptive(
                         strokeWidth: 5,
                         backgroundColor: primaryColor,
                       )
                     ) :  RawMaterialButton(
                          onPressed: () {
                            _startPosting();
                            if(_priceController.text == "" || _currentSelectedPaymentMethod == "Select payment method"){
                              Get.snackbar("Field Error", "all fields are required.",
                                  duration: const Duration(seconds: 4),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: defaultTextColor1);
                            }
                            else{
                              _endingTrip();
                              setState(() {
                                isEndingTrip = true;
                              });
                              controller.driverEndTrip(controller.passengerId,title,_priceController.text.trim(),_currentSelectedPaymentMethod,timeElapsed);
                              if(controller.scheduleType == "One Time"){
                                controller.updateRide(controller.passengerId, id);
                              }
                              // Get.back();
                              setState(() {
                                _priceController.text = "";
                                _currentSelectedPaymentMethod = "Select payment method";
                              });
                            }
                          },
                          // child: const Text("Send"),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  8)),
                          elevation: 8,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Save & End Trip",
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
                    )
                ),
              ) :
              Padding(
                padding: const EdgeInsets.only(left:10, right:10,),
                child: Card(
                    elevation:12,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // const Text("Passenger",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                    // const SizedBox(width:10),
                                    buildTime(),
                                    controller.rideStarted ? isEndingTrip ? const Center(
                                        child: CircularProgressIndicator.adaptive(
                                          strokeWidth: 5,
                                          backgroundColor: primaryColor,
                                        )
                                    ) : RawMaterialButton(
                                      onPressed: () {
                                        // _endingTrip();
                                        setState(() {
                                          isEndingTrip = true;
                                          tripStarted = false;
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
                                        padding: EdgeInsets.all(8.0),
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
                                      fillColor:
                                      Colors.red,
                                      splashColor:
                                      defaultColor,
                                    ) :  isStartingTrip ? const Center(
                                        child: CircularProgressIndicator.adaptive(
                                          strokeWidth: 5,
                                          backgroundColor: primaryColor,
                                        )
                                    ) :
                                    RawMaterialButton(
                                      onPressed: () {
                                        _startingTrip();
                                        setState(() {
                                          isStartingTrip = true;
                                          tripStarted = true;
                                        });
                                        controller.driverStartTrip(controller.passengerId,title);
                                      //  start timer here
                                        startTimer();
                                      },
                                      // child: const Text("Send"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              8)),
                                      elevation: 8,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
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
                                const SizedBox(height:10),
                                // passenger profile pic,name and alert arrival button
                        Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GetBuilder<ScheduleController>(
                                          builder: (controller) {
                                            return controller.passengerPic == "" ? const ShimmerWidget.circular(width: 40,height: 40) : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  controller.
                                                  passengerPic),
                                              radius: 30,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 20,),
                                        GetBuilder<ScheduleController>(builder: (controller) {
                                          return controller.passengerWithSchedule == "" ? const ShimmerWidget.rectangular(height: 20) : Text("${controller.passengerWithSchedule.toString().capitalize}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15));
                                        }),
                                      ],
                                    ),
                                    const SizedBox(width:20),
                                    isPosting ? const Center(
                                        child: CircularProgressIndicator.adaptive(
                                          strokeWidth: 5,
                                          backgroundColor: primaryColor,
                                        )
                                    ) :
                                    RawMaterialButton(
                                      onPressed: () {

                                        showMaterialModalBottomSheet(
                                          context: context,
                                          // expand: true,
                                          isDismissible: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      25.0))),
                                          bounce: true,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: SizedBox(
                                                height: 300,
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(height: 30),
                                                    const Center(
                                                        child: Text(
                                                            "Alert passenger of your arrival by",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                    const SizedBox(height: 30),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children:[
                                                          Expanded(
                                                            child: GestureDetector(
                                                                child: Column(
                                                                  children: const [
                                                                    Icon(FontAwesomeIcons.bell,size:30),
                                                                    SizedBox(height:20),
                                                                    Text("Notification",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  _startPosting();
                                                                  setState(() {
                                                                    isPosting = true;
                                                                  });
                                                                  controller.driverAlertPassenger(controller.passengerId);
                                                                  Navigator.pop(context);
                                                                }
                                                            ),
                                                          ),

                                                          Expanded(
                                                            child: GestureDetector(
                                                                child: Column(
                                                                  children: const [
                                                                    Icon(Icons.phone,size:30),
                                                                    SizedBox(height:20),
                                                                    Text("Phone Call",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  // dial(controller.passengerPhoneNumber);
                                                                  _callNumber(controller.passengerPhoneNumber);
                                                                }
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                  ],
                                                )),
                                          ),
                                        );
                                      },
                                      // child: const Text("Send"),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              8)),
                                      elevation: 8,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
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
                                      fillColor:
                                      Colors.green,
                                      splashColor:
                                      defaultColor,
                                    )
                                  ],
                                )

                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Schedule Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.scheduleType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.scheduleType);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Schedule Priority",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.schedulePriority == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.schedulePriority);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.description == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.description);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Ride Type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.rideType == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.rideType);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Pickup Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.pickUpLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.pickUpLocation);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Drop Off Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.dropOffLocation == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.dropOffLocation);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Pick up time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.pickUpTime == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.pickUpTime);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Start Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.startDate == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.startDate);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Status",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.status == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.status);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Date Requested",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.dateRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.dateRequested);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Time Requested",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.timeRequested == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.timeRequested.toString().split(".").first);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Price",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.price == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.price);
                                })
                              ]
                          ),
                          const SizedBox(height:10),
                          const Divider(),
                          const SizedBox(height:10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Charge",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                const SizedBox(height:10),
                                GetBuilder<ScheduleController>(builder: (controller) {
                                  return controller.charge == "" ? const ShimmerWidget.rectangular(height: 20) : Text(controller.charge);
                                })
                              ]
                          ),
                        ],
                      ),
                    )
                ),
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

  Widget buildTime(){
    String twoDigits(int n)=> n.toString().padLeft(2,'0');
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
        buildTimeCard(time:hours, header: "H"),
        const SizedBox(width:10),
        buildTimeCard(time:minutes, header: "Min"),
        const SizedBox(width:10),
        buildTimeCard(time:seconds,header:"Sec")
      ],
    );
  }

  Widget buildTimeCard({required String time, required String header}){

    return Container(
      decoration: BoxDecoration(
        color:primaryColor,
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
              Text(
                time,style: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 15)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
