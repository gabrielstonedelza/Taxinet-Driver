import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../constants/app_colors.dart';


class UserController extends GetxController {
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  String driverProfileId = "";
  String driverUsername = "";
  String profileImage = "";
  String driversLicense = "";
  String licenseExpiration = "";
  String licensePlate = "";
  String licenseNumber = "";
  String carModel = "";
  String carName = "";
  String taxinetNumber = "";
  String nameOnGhanaCard = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String uniqueCode = "";
  String driversTrackerSim = "";
  late bool verified;
  bool isVerified = false;
  late String updateUserName;
  late String updateEmail;
  late String updatePhone;
  bool isUpdating = false;
  var dio = Dio();
  bool hasUploadedFrontCard = false;
  bool hasUploadedBackCard = false;

  late List profileDetails = [];
  late List profileDetails1 = [];
  late List passengerUserNames = [];
  late List driversUniqueCodes = [];
  late List allDrivers = [];
  late List driversNames = [];
  late List passengerNames = [];
  late List passengersUniqueCodes = [];
  late List allPassengers = [];
  late List allUsersUniqueCodes = [];
  late List allUserNames = [];

  bool isLoading = true;
  bool isOpened = false;
  late Timer _timer;

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
  }

  File? profileImageUpload;
  File? frontCard;
  File? backCard;

  Future<void> getAllUsers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_users/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers = jsonData;
        for (var i in allDrivers) {
          if(!allUsersUniqueCodes.contains(i['unique_code'])){
            allUsersUniqueCodes.add(i['unique_code']);
          }
        }
        update();

      }
      else{
        if (kDebugMode) {
          print("response.body");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }


  Future<void> getUserProfile(String token) async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/driver-profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        for (var i in profileDetails) {
          profileImage = i['driver_profile_pic'];
          nameOnGhanaCard = i['name_on_ghana_card'];
          email = i['get_drivers_email'];
          phoneNumber = i['get_drivers_phone_number'];
          fullName = i['get_drivers_full_name'];
          driversTrackerSim = i['get_driver_tracker_sim_number'];
          driversLicense = i['get_drivers_license'];
          licenseExpiration = i['license_expiration_date'];
          licensePlate = i['license_plate'];
          licenseNumber = i['license_number'];
          carModel = i['car_model'];
          carName = i['car_name'];
          taxinetNumber = i['taxinet_number'];
          verified = i['verified'];
          driverProfileId = i['user'].toString();
          driverUsername = i['username'];
        }
        update();
        storage.write("verified", "Verified");
        storage.write("profile_id", driverProfileId);
        storage.write("profile_name", fullName);
        storage.write("profile_pic", profileImage);
        storage.write("passenger_username", driverUsername);
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getUserDetails(String token) async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/get_user/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails1 = jsonData;
        // print(profileDetails1);
        for (var i in profileDetails1) {
          uniqueCode = i['unique_code'];
        }
        update();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

}
