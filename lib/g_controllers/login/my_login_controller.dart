import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../bottomnavigation.dart';
import '../../constants/app_colors.dart';
import '../../views/login/loginview.dart';

class MyLoginController extends GetxController{
  static MyLoginController get to => Get.find<MyLoginController>();
  final storage = GetStorage();
  var username = "";
  final password = "";

  late List allDrivers = [];

  late List driversUserNames = [];

  bool isLoading = true;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllDrivers();
  }

  Future<void> getAllDrivers() async{
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/all_drivers";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers.assignAll(jsonData);
        for(var i in allDrivers){
          driversUserNames.add(i['username']);
        }
        update();
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      isLoading = false;
    }
  }

  loginUser(String uname, String uPassword) async {
    const loginUrl = "https://taxinetghana.xyz/auth/token/login/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": uname, "password": uPassword});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      var userId = jsonData['user'];
      storage.write("username", uname);
      storage.write("userToken", userToken);
      storage.write("userType", "Driver");
      storage.write("userid", userId);
      update();
      if (driversUserNames.contains(uname)) {
        Timer(const Duration(seconds: 5), () =>
            Get.offAll(() => const MyBottomNavigationBar()));
      }
      else {
        Get.snackbar("Sorry 😢", response.body,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: defaultTextColor1);
        Get.offAll(() => const LoginView());
      }
    }
  }
}