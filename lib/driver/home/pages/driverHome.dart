import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../bottomnavigation.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/mapcontroller.dart';
import '../../../controllers/notificationController.dart';
import '../../../controllers/notifications/localnotification_manager.dart';
import '../../../controllers/schedulescontroller.dart';
import '../../../controllers/walletcontroller.dart';
import '../../../g_controllers/user/user_controller.dart';
import '../../../widgets/shimmers/shimmerwidget.dart';
import '../paymentmethods.dart';
import '../scheduledetail.dart';
import '../transfers/transfers.dart';
import 'notifications.dart';



class DriverHome extends StatefulWidget {
  DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  String greetingMessage(){
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  UserController userController = Get.find();

  WalletController walletController = Get.find();

  ScheduleController scheduleController = Get.find();

  final MapController _mapController = Get.find();

  final storage = GetStorage();

  late String username = "";

  late String uToken = "";

  late String userid = "";

  var items;

  bool isFetching = true;

  bool isLoading = true;

  late List allNotifications = [];

  late List yourNotifications = [];

  late List notRead = [];

  late List triggered = [];

  late List unreadNotifications = [];

  late List triggeredNotifications = [];

  late List notifications = [];

  late List allNots = [];

  late Timer _timer;
  NotificationController notificationController = Get.find();

  Future<void> getAllTriggeredNotifications() async {
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

  Future<void> getAllUnReadNotifications() async {
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

  Future<void> getAllNotifications() async {
    const url = "https://taxinetghana.xyz/get_all_driver_notifications/";
    var myLink = Uri.parse(url);
    final response =
    await http.get(myLink, headers: {"Authorization": "Token $uToken"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
      allNots.assignAll(allNotifications);
    }
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
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  processLoadWallet() async {
    const depositUrl = "https://taxinetghana.xyz/request_to_load_drivers_wallet/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "driver": userid,
      "amount": amountController.text,
    });
    if (res.statusCode == 201) {
      Get.snackbar("Congratulations", "Request sent.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);

      setState(() {
        amountController.text = "";
      });
      // Navigator.pop(context);
      // Get.offAll(() => const MyBottomNavigationBar());
    } else {
      // print(res.body);
      Get.snackbar("Error", "Something went wrong,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }

  @override
  void initState() {
    super.initState();
    _mapController.getUserLocation();

    // ignore: todo
    // TODO: implement initState
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("userid") != null) {
      userid = storage.read("userid");
    }

    scheduleController.getActiveSchedules(uToken);
    scheduleController.getAllSchedules(uToken);
    scheduleController.getDriversOneTimeSchedules(uToken);
    scheduleController.getDriversDailySchedules(uToken);
    scheduleController.getDriversDaysSchedules(uToken);
    scheduleController.getDriversWeeklySchedules(uToken);
    scheduleController.getDriversMonthlySchedules(uToken);
    notificationController.getAllNotifications(uToken);
    notificationController.getAllUnReadNotifications(uToken);
    walletController.getUserWallet(uToken);
    userController.getUserProfile(uToken);
    userController.getAllDrivers();
    userController.getAllPassengers();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      scheduleController.getActiveSchedules(uToken);
      scheduleController.getAllSchedules(uToken);
      scheduleController.getDriversOneTimeSchedules(uToken);
      scheduleController.getDriversDailySchedules(uToken);
      scheduleController.getDriversDaysSchedules(uToken);
      scheduleController.getDriversWeeklySchedules(uToken);
      scheduleController.getDriversMonthlySchedules(uToken);
      walletController.getUserWallet(uToken);
      userController.getUserProfile(uToken);
      userController.getAllDrivers();
      userController.getAllPassengers();
      notificationController.getAllNotifications(uToken);
      notificationController.getAllUnReadNotifications(uToken);

    });

    getAllTriggeredNotifications();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getAllTriggeredNotifications();
      getAllUnReadNotifications();
      for (var i in triggered) {
        localNotificationManager.showRideRequests(
            i['notification_title'], i['notification_message']);
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

  //notifications localNotificationManager
  onRideRequestNotification(ReceiveNotification notification) {}

  onRideRequestNotificationClick(String payload) {
    Get.to(() => const MyBottomNavigationBar());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body:  ListView(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: primaryColor,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        showMaterialModalBottomSheet(
                          context: context,
                          // expand: true,
                          isDismissible: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(
                                  top: Radius.circular(25.0))),
                          bounce: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom),
                            child: SizedBox(
                                height: 250,
                                child: Column(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 30),
                                    const Center(
                                        child: Text(
                                            "How much would you like to load into your wallet?",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold))),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          18.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  bottom:
                                                  10.0),
                                              child:
                                              TextFormField(
                                                controller:
                                                amountController,
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
                                            const SizedBox(
                                                height: 20),
                                            RawMaterialButton(
                                              onPressed:
                                                  () {
                                                if(amountController.text == ""){
                                                  Get.snackbar("Amount Error", "please enter amount to load",
                                                      duration: const Duration(seconds: 4),
                                                      snackPosition: SnackPosition.BOTTOM,
                                                      backgroundColor: Colors.red,
                                                      colorText: defaultTextColor1);
                                                }
                                                else{
                                                  Get.back();
                                                  Get.to(()=> PaymentMethods(amount:amountController.text));
                                                }
                                              },
                                              // child: const Text("Send"),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(8)),
                                              elevation:
                                              8,
                                              fillColor:
                                              defaultBlack,
                                              splashColor:
                                              defaultColor,
                                              child:
                                              const Text(
                                                "Top Up",
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold,
                                                    fontSize:
                                                    15,
                                                    color:
                                                    defaultTextColor1),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/deposit.png",width: 50, height: 50),
                          const SizedBox(height: 10),
                          const Text("Top Up",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on),
                                GetBuilder<MapController>(builder: (controller){
                                  return _mapController.isLoading ? const ShimmerWidget.rectangular(width: 100, height: 20) : Text(_mapController.myLocationName,
                                      style: const TextStyle(fontWeight: FontWeight.bold,color: secondaryColor,fontSize: 15));
                                })
                              ],
                            )),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: userController.profileImageUpload !=
                            null
                            ? GetBuilder<UserController>(
                          builder: (controller) {
                            return CircleAvatar(
                              backgroundImage: FileImage(
                                  userController
                                      .profileImageUpload!),
                              radius: size.width * 0.14,
                              backgroundColor: Colors.pink,
                            );
                          },
                        )
                            : GetBuilder<UserController>(
                          builder: (controller) {
                            return userController.isLoading ? const ShimmerWidget.circular(width: 100, height: 100) : userController.profileImage == "" ? const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/user.png"),
                              radius: 50,
                            ) :CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userController.profileImage),
                              radius: size.width * 0.14,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(child: GetBuilder<WalletController>(
                            builder: (controller) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.account_balance_wallet),
                                  const SizedBox(width:10),
                                  walletController.isLoading ? const ShimmerWidget.rectangular(width: 100, height: 20) :  Text(
                                      "GHS ${walletController.wallet}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              );
                            })),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Get.to(()=> const Transfers());
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/transfer.png",width: 50,height: 50),
                              const SizedBox(height: 10),
                              const Text("Transfer",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ))
                  )
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    SlideInUp(
                      animate: true,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                  child: Text("Schedules",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: defaultTextColor2),)
                              ),
                              const SizedBox(height: 10,),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: SizedBox(
                                                  height: 600,
                                                  child: ListView.builder(
                                                      itemCount: scheduleController.activeSchedules != null ? scheduleController.activeSchedules.length : 0,
                                                      itemBuilder: (context,index){
                                                        items = scheduleController.activeSchedules[index];
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 10, right: 10,),
                                                          child: SlideInUp(
                                                            animate: true,
                                                            child: Card(
                                                                elevation: 12,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: ListTile(
                                                                    onTap: (){
                                                                      Get.to(()=> ScheduleDetail(slug:scheduleController.activeSchedules[index]['slug'],title:scheduleController.activeSchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                    },
                                                                    leading: const Icon(Icons.access_time_filled),
                                                                    title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                    subtitle: Padding(
                                                                      padding: const EdgeInsets.only(top:10.0),
                                                                      child: Text(items['date_scheduled']),
                                                                    )
                                                                )
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (controller){
                                                        return Text("${scheduleController.activeSchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("Active",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height: 600,
                                                      child:  ListView.builder(
                                                          itemCount: scheduleController.allOneTimeSchedules != null ? scheduleController.allOneTimeSchedules.length : 0,
                                                          itemBuilder: (context,index){
                                                            items = scheduleController.allOneTimeSchedules[index];
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 10, right: 10,),
                                                              child: SlideInUp(
                                                                animate: true,
                                                                child: Card(
                                                                    elevation: 12,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    child: ListTile(
                                                                        onTap: (){
                                                                          Get.to(()=> ScheduleDetail(slug:scheduleController.allOneTimeSchedules[index]['slug'],title:scheduleController.allOneTimeSchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                          // Navigator.pop(context);
                                                                        },
                                                                        leading: const Icon(Icons.access_time_filled),
                                                                        title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                        subtitle: Padding(
                                                                          padding: const EdgeInsets.only(top:10.0),
                                                                          child: Text(items['date_scheduled']),
                                                                        )
                                                                    )
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (controller){
                                                        return Text("${scheduleController.allOneTimeSchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("One Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: SizedBox(
                                                  height: 600,
                                                  child: ListView.builder(
                                                      itemCount: scheduleController.allDailySchedules != null ? scheduleController.allDailySchedules.length : 0,
                                                      itemBuilder: (context,index){
                                                        items = scheduleController.allDailySchedules[index];
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 10, right: 10,),
                                                          child: SlideInUp(
                                                            animate: true,
                                                            child: Card(
                                                                elevation: 12,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: ListTile(
                                                                    onTap: (){
                                                                      Get.to(()=> ScheduleDetail(slug:scheduleController.allDailySchedules[index]['slug'],title:scheduleController.allDailySchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                    },
                                                                    leading: const Icon(Icons.access_time_filled),
                                                                    title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                    subtitle: Padding(
                                                                      padding: const EdgeInsets.only(top:10.0),
                                                                      child: Text(items['date_scheduled']),
                                                                    )
                                                                )
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (_){
                                                        return Text("${scheduleController.allDailySchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })

                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("Daily",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: SizedBox(
                                                  height: 600,
                                                  child: ListView.builder(
                                                      itemCount: scheduleController.allDaysSchedules != null ? scheduleController.allDaysSchedules.length : 0,
                                                      itemBuilder: (context,index){
                                                        items = scheduleController.allDaysSchedules[index];
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 10, right: 10,),
                                                          child: SlideInUp(
                                                            animate: true,
                                                            child: Card(
                                                                elevation: 12,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: ListTile(
                                                                    onTap: (){
                                                                      Get.to(()=> ScheduleDetail(slug:scheduleController.allDaysSchedules[index]['slug'],title:scheduleController.allDaysSchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                    },
                                                                    leading: const Icon(Icons.access_time_filled),
                                                                    title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                    subtitle: Padding(
                                                                      padding: const EdgeInsets.only(top:10.0),
                                                                      child: Text(items['date_scheduled']),
                                                                    )
                                                                )
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  )
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (_){
                                                        return Text("${scheduleController.allDaysSchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("Days",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height: 600,
                                                      child:  ListView.builder(
                                                          itemCount: scheduleController.allWeeklySchedules != null ? scheduleController.allWeeklySchedules.length : 0,
                                                          itemBuilder: (context,index){
                                                            items = scheduleController.allWeeklySchedules[index];
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 10, right: 10,),
                                                              child: SlideInUp(
                                                                animate: true,
                                                                child: Card(
                                                                    elevation: 12,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    child: ListTile(
                                                                        onTap: (){
                                                                          Get.to(()=> ScheduleDetail(slug:scheduleController.allWeeklySchedules[index]['slug'],title:scheduleController.allWeeklySchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                          // Navigator.pop(context);
                                                                        },
                                                                        leading: const Icon(Icons.access_time_filled),
                                                                        title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                        subtitle: Padding(
                                                                          padding: const EdgeInsets.only(top:10.0),
                                                                          child: Text(items['date_scheduled']),
                                                                        )
                                                                    )
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (_){
                                                        return Text("${scheduleController.allWeeklySchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("Weekly",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.vertical(
                                                    top: Radius.circular(
                                                        25.0))),
                                            bounce: true,
                                            builder: (context) => SingleChildScrollView(
                                              controller: ModalScrollController.of(context),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height: 600,
                                                      child:  ListView.builder(
                                                          itemCount: scheduleController.allMonthlySchedules != null ? scheduleController.allMonthlySchedules.length : 0,
                                                          itemBuilder: (context,index){
                                                            items = scheduleController.allMonthlySchedules[index];
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 10, right: 10,),
                                                              child: SlideInUp(
                                                                animate: true,
                                                                child: Card(
                                                                    elevation: 12,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    child: ListTile(
                                                                        onTap: (){
                                                                          Get.to(()=> ScheduleDetail(slug:scheduleController.allMonthlySchedules[index]['slug'],title:scheduleController.allMonthlySchedules[index]['schedule_title'],id:scheduleController.allSchedules[index]['id'].toString()));
                                                                          // Navigator.pop(context);
                                                                        },
                                                                        leading: const Icon(Icons.access_time_filled),
                                                                        title: Text(items['schedule_title'],style:const TextStyle(fontWeight: FontWeight.bold)),
                                                                        subtitle: Padding(
                                                                          padding: const EdgeInsets.only(top:10.0),
                                                                          child: Text(items['date_scheduled']),
                                                                        )
                                                                    )
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            color: greyBack,
                                            height: 85,
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Icon(FontAwesomeIcons.fire,color: primaryColor,),
                                                      GetBuilder<ScheduleController>(builder: (_){
                                                        return Text("${scheduleController.allWeeklySchedules.length}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),);
                                                      })
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  const Text("Monthly",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: pearl),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10,),

                            ],
                          ),
                        ],
                      ),
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
