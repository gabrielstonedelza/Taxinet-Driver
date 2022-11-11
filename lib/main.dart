import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taxinet_driver/g_controllers/login/my_login_controller.dart';
import 'package:taxinet_driver/g_controllers/user/user_controller.dart';
import 'package:taxinet_driver/splash.dart';
import 'package:get/get.dart';

import 'controllers/inventorycontroller.dart';
import 'controllers/mapcontroller.dart';
import 'controllers/notificationController.dart';
import 'controllers/salarycontroller.dart';
import 'controllers/schedulescontroller.dart';
import 'controllers/walletcontroller.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(MyLoginController());
  Get.put(UserController());
  Get.put(ScheduleController());
  Get.put(NotificationController());
  Get.put(WalletController());
  Get.put(InventoryController());
  Get.put(MapController());
  Get.put(SalaryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRight,
      theme: ThemeData(
// This is the theme of your application.
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.sansitaSwashedTextTheme(Theme.of(context).textTheme)

      ),
      home: const SplashScreen(),
    );
  }
}