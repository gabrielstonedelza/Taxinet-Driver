
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:taxinet_driver/sendsms.dart';
import 'controllers/notificationController.dart';
import 'controllers/notifications/localnotification_manager.dart';
import 'driver/home/accountblocked.dart';
import 'driver/home/closeappfortheday.dart';
import 'driver/home/myprofile.dart';
import 'driver/home/pages/inventories.dart';
import 'driver/home/pages/notifications.dart';
import 'driver/home/pages/driverHome.dart';
import 'g_controllers/user/user_controller.dart';


class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";
  int selectedIndex = 0;
  late PageController pageController;
  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  NotificationController notificationController = Get.find();
  final UserController userController = Get.find();
  late List allBlockedUsers = [];
  late List blockedUsernames = [];
  bool isBlocked = false;
  bool isLoading = true;
  late Timer _timer;
  bool isClosingTime = false;
  bool hasAlertLocked = false;
  int alertLockCount = 0;
  int alertUnLockCount = 0;
  int alertLock = 0;

  fetchBlockedAgents()async{
    const url = "https://fnetghana.xyz/get_blocked_users/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink,);
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allBlockedUsers = json.decode(jsonData);
      for(var i in allBlockedUsers){
        if(!blockedUsernames.contains(i['get_username'])){
          blockedUsernames.add(i['get_username']);
        }
      }
    }

    setState(() {
      isLoading = false;
      allBlockedUsers = allBlockedUsers;
    });
  }

  final screens = [
    DriverHome(),
    const Inventories(),
    Notifications(),
    const MyProfile(),
  ];
  final SendSmsController sendSms = SendSmsController();

  void onSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  void checkTheTime(){
    var hour = DateTime.now().hour;
    switch (hour) {
      case 23:
        String driversPhone = userController.phoneNumber;
        driversPhone = driversPhone.replaceFirst("0", '+233');
        if (alertLockCount == 0){
          sendSms.sendMySms(driversPhone, "Taxinet",
              "Attention!,please be advised, your car will be locked in one hour time,thank you.");
        }
        setState(() {
          alertLockCount = 1;
        });

        break;
      case 00:
        setState(() {isClosingTime = true;});
        String driversPhone = userController.phoneNumber;
        driversPhone = driversPhone.replaceFirst("0", '+233');
        // function to lock car
        String trackerSim = userController.driversTrackerSim;
        trackerSim = trackerSim.replaceFirst("0", '+233');

        if (alertLock == 0){
          // sendSms.sendMySms(driversPhone, "Taxinet",
          //     "Attention!,your car is locked.");
          sendSms.sendMySms(trackerSim, "0244529353", "relay,1\%23#");
          localNotificationManager.showCarLockNotification("Car Locked", "Your car is locked and will be unlocked at working hours.");
        }
        setState(() {
          alertLock = 1;
        });
        break;
      case 01:
        setState(() {isClosingTime = true;});
        break;
      case 02:
        setState(() {isClosingTime = true;});
        break;
      case 03:
        setState(() {isClosingTime = true;});
        break;
      case 04:
        String driversPhone = userController.phoneNumber;
        driversPhone = driversPhone.replaceFirst("0", '+233');
        if (alertUnLockCount == 0){
          localNotificationManager.showCarUnLockNotification("App Unlocked", "Hi good morning,your app is now accessible,please make payment and unlock your car.Thank you.");
        }
        setState(() {
          alertUnLockCount = 1;
        });
        break;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    pageController = PageController(initialPage: selectedIndex);
    fetchBlockedAgents();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchBlockedAgents();
      checkTheTime();
    });
  }

  @override
  void dispose(){
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: blockedUsernames.contains(username) ? const Scaffold(
            body: AccountBlockNotification()
        ) :Scaffold(
          bottomNavigationBar: NavigationBarTheme(

            data: NavigationBarThemeData(
                indicatorColor: Colors.blue.shade100,
                labelTextStyle:  MaterialStateProperty.all(
                    const TextStyle(fontSize:14, fontWeight: FontWeight.bold)
                )
            ),
            child: NavigationBar(
              animationDuration: const Duration(seconds: 3),
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) => setState((){
                selectedIndex = index;
              }),
              height: 60,
              backgroundColor: Colors.white,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home",
                ),
                const NavigationDestination(
                  icon: Icon(Icons.checklist_rtl_outlined),
                  selectedIcon: Icon(Icons.checklist_rtl_rounded),
                  label: "Inventories",
                ),
                GetBuilder<NotificationController>(builder: (controller){
                  return NavigationDestination(
                    icon: Badge(
                        animationDuration: const Duration(seconds: 3),
                        // padding: const EdgeInsets.all(2),
                        // position: BadgePosition.bottomStart(),
                        toAnimate: true,
                        shape: BadgeShape.circle,
                        badgeColor: Colors.red,
                        // borderRadius: BorderRadius.circular(8),
                        badgeContent: Text("${notificationController.notRead.length}",style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize:15)),
                        child: const Icon(Icons.notifications_outlined)),
                    selectedIcon: const Icon(Icons.notifications),
                    label: "Notifications",
                  );
                }),
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
          body: isClosingTime ? const CloseAppForDay() : screens[selectedIndex],
        )
    );
  }
}
