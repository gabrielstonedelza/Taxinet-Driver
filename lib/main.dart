import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'package:taxinet_driver/controllers/login/login_controller.dart';
import 'package:taxinet_driver/g_controllers/login/my_login_controller.dart';
import 'package:taxinet_driver/g_controllers/user/user_controller.dart';
import 'package:taxinet_driver/splash.dart';
import 'package:taxinet_driver/states/app_state.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(MyLoginController());
  Get.put(UserController());
  Get.put(DeMapController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(context)=> AppState()),
        ChangeNotifierProvider(create:(context)=> LoginController()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.upToDown,
        theme: ThemeData(
// This is the theme of your application.
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
