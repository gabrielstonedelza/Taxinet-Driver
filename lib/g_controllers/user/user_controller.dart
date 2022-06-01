import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  static UserController get to => Get.find<UserController>();
  final storage = GetStorage();
  var username = "";
  var uToken = "";
  late List userProfile = [];
  late List userData = [];
  var userId = "";
  var profilePic = "";
  var driversLicense = "";
  var taxinetNumber = "";
  var ghCard = "";
  var cardName = "";
  var cardNumber = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    getUserInfo(uToken);
    getUserProfile(uToken);
  }

  Future<void> getUserInfo(String token) async {
    const userUrl = "https://taxinetghana.xyz/get_user/";
    final myUser = Uri.parse(userUrl);
    final response =
        await http.get(myUser, headers: {"Authorization": "Token $token"});
    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userData = json.decode(jsonData);
      for (var i in userData) {
        userId = i['id'].toString();
      }
      storage.write("user_id", userId);
      update();
    } else {
      Get.snackbar("Error", "Couldn't find user data",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

//
  Future<void> getUserProfile(String token) async {
    const profileUrl = "https://taxinetghana.xyz/passenger-profile/";
    final myProfile = Uri.parse(profileUrl);
    final response =
        await http.get(myProfile, headers: {"Authorization": "Token $token"});

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userProfile = json.decode(jsonData);
      for (var i in userProfile) {
        profilePic = i['passenger_profile_pic'];
        driversLicense = i['drivers_license'];
        taxinetNumber = i['taxinet_number'];
        cardName = i['name_on_ghana_card'];
        cardNumber = i['ghana_card_number'];
      }
      update();
    } else {
      // Get.snackbar("Error", "Couldn't find user data",
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red);
    }
  }
}
