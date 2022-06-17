import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:taxinet_driver/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:taxinet_driver/driver/home/d_home.dart';
import 'package:taxinet_driver/driver/home/pages/messages.dart';
import 'package:taxinet_driver/driver/home/pages/notifications.dart';
import 'package:taxinet_driver/driver/home/pages/profile_tab.dart';
import 'package:taxinet_driver/driver/home/pages/rides_tab.dart';

Widget myFabMenu(){

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  return FabCircularMenu(
    alignment: Alignment.topRight,
    fabColor: primaryColor,
    fabOpenColor: secondaryColor,
    ringDiameter: 250.0,
    ringWidth: 60.0,
    ringColor: defaultTextColor2,
    fabSize: 60.0,
    fabElevation: 12,
    children: [
      IconButton(
        onPressed: (){
          Get.to(() => const NewDriverHome());
        },
        icon: const Icon(Icons.home,color: primaryColor,),
      ),
      IconButton(
        onPressed: (){
          Get.to(() => const Rides());
        },
        icon: const Icon(Icons.access_time_sharp,color: primaryColor),
      ),
      IconButton(
        onPressed: (){
          Get.to(() => const Notifications());
        },
        icon: const Icon(Icons.notifications,color: primaryColor),
      ),
      IconButton(
        onPressed: (){
          Get.to(() => const ProfilePage());
        },
        icon: const Icon(Icons.person,color: primaryColor),
      ),
    ],
  );
}