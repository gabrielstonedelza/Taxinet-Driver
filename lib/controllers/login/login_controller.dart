import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../driver/home/driver_home.dart';
import '../../views/login/loginview.dart';

class LoginController extends ChangeNotifier {
  final client = http.Client();
  final storage = GetStorage();

  var username = "";
  late final password = "";
  var userType = "";
  String userId = "";
  late List userData = [];
  late List allDrivers = [];

  late List driversUserNames = [];

  late List userProfile = [];
  var profilePic = "";
  var ghCard = "";
  var cardName = "";
  var cardNumber = "";
  var nextOfKin = "";
  var nextOfKinNum = "";
  var referral = "";
  var referralNum = "";
  late bool verified;
  String get uId => userId;
  List get taxinetDrivers => allDrivers;
  List get dUsernames => driversUserNames;

  String get uName => username;
  String get userProfilePic => profilePic;
  List get userInfoData => userProfile;
  String get uType => userType;
  bool isFetching = true;

  bool get fetchingStatus => isFetching;


  Future<void> getAllDrivers() async {
    try {
      isFetching = true;
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
        notifyListeners();
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      isFetching = false;
    }
  }

  loginUser(String uname, String uPassword) async {
    const loginUrl = "https://taxinetghana.xyz/auth/token/login/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await client.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": uname, "password": uPassword});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      storage.write("username", uname);
      storage.write("userToken", userToken);
      storage.write("userType", "Driver");

      username = uname;
      if (driversUserNames.contains(uname)) {
        Timer(const Duration(seconds: 5), () =>
            Get.offAll(() => const DriverHome()));
      }
      else {
        Get.snackbar("Error 😢", "You are not a driver or invalid credentials provided",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5)
        );
        Get.offAll(() => const LoginView());
      }
    }

    // Future<void> getUserInfo(String token) async {
    //   const userUrl = "https://taxinetghana.xyz/get_user/";
    //   final myUser = Uri.parse(userUrl);
    //   final response =
    //   await http.get(myUser, headers: {"Authorization": "Token $token"});
    //   if (response.statusCode == 200) {
    //     final codeUnits = response.body.codeUnits;
    //     var jsonData = const Utf8Decoder().convert(codeUnits);
    //     userData = json.decode(jsonData);
    //     for (var i in userData) {
    //       userType = i['user_type'];
    //       userId = i['id'].toString();
    //     }
    //     storage.write("user_type", userType);
    //     storage.write("user_id", userId);
    //   } else {
    //     Get.snackbar("Error", "Couldn't find user data",
    //         colorText: Colors.white,
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.red);
    //   }
    // }
    //
    // Future<void> getUserProfile(String token) async {
    //   const profileUrl = "https://taxinetghana.xyz/passenger-profile/";
    //   final myProfile = Uri.parse(profileUrl);
    //   final response =
    //   await http.get(myProfile, headers: {"Authorization": "Token $token"});
    //
    //   if (response.statusCode == 200) {
    //     final codeUnits = response.body.codeUnits;
    //     var jsonData = const Utf8Decoder().convert(codeUnits);
    //     userProfile = json.decode(jsonData);
    //     for (var i in userProfile) {
    //       profilePic = i['passenger_profile_pic'];
    //     }
    //   } else {
    //     Get.snackbar("Error", "Couldn't find user data",
    //         colorText: Colors.white,
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.red);
    //   }
    // }
  }
}
