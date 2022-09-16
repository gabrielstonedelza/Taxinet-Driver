
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../constants/app_colors.dart';
import 'controllers/notificationController.dart';
import 'driver/home/myprofile.dart';
import 'driver/home/nointernetconnection.dart';
import 'driver/home/pages/inventories.dart';
import 'driver/home/pages/notifications.dart';
import 'driver/home/pages/driverHome.dart';


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

  void onSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
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
  }

  @override
  void dispose(){
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: hasInternet ? <Widget>[
            DriverHome(),
            const Inventories(),
            const Notifications(),
            const MyProfile(),
          ] : <Widget>[
            const NoInternetConnection()
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color:Colors.white)
          ),
          child: WaterDropNavBar(
            backgroundColor: Colors.white,
            inactiveIconColor: Colors.grey,
            bottomPadding: 10.0,
            waterDropColor: primaryColor,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
              pageController.animateToPage(selectedIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuad);
            },
            selectedIndex: selectedIndex,
            barItems: [
              BarItem(
                filledIcon: Icons.home,
                outlinedIcon: Icons.home_outlined,
              ),

              BarItem(
                  filledIcon: Icons.assessment,
                  outlinedIcon: Icons.assessment_outlined),

              BarItem(
                filledIcon: Icons.notifications,
                outlinedIcon: Icons.notifications_outlined,
              ),
              BarItem(
                filledIcon: Icons.person,
                outlinedIcon: Icons.person_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
