import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class ScheduleController extends GetxController{
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  List activeSchedules = [];
  List allSchedules = [];
  List allOneTimeSchedules = [];
  List allDailySchedules = [];
  List allWeeklySchedules = [];
  List allDaysSchedules = [];
  List allMonthlySchedules = [];
  List detailScheduleItems = [];
  String passengerId = "";
  String passengerWithSchedule = "";
  String passengerPic = "";
  String passengerPhoneNumber = "";
  String scheduleType = "";
  String schedulePriority = "";
  String rideType = "";
  String pickUpLocation = "";
  String dropOffLocation = "";
  String pickUpTime = "";
  String startDate = "";
  String status = "";
  String dateRequested = "";
  String timeRequested = "";
  String description = "";
  String price = "";
  String scheduleRideId = "";
  String charge = "";
  bool rideStarted = false;
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
    // getActiveSchedules();
    // getAllSchedules();
    // getDriversOneTimeSchedules();
    // getDriversDailySchedules();
    // getDriversDaysSchedules();
    // getDriversWeeklySchedules();
    // getDriversMonthlySchedules();
    // _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   getActiveSchedules();
    //   getAllSchedules();
    //   getDriversOneTimeSchedules();
    //   getDriversDailySchedules();
    //   getDriversDaysSchedules();
    //   getDriversWeeklySchedules();
    //   getDriversMonthlySchedules();
    //   update();
    // });
  }
  Future<void> getDetailSchedule(String slug) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/ride_requests/$slug/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        passengerWithSchedule = jsonData['get_passenger_name'];
        passengerPic = jsonData['get_passenger_profile_pic'];
        scheduleType = jsonData['schedule_type'];
        schedulePriority = jsonData['schedule_priority'];
        description = jsonData['schedule_description'];
        rideType = jsonData['ride_type'];
        pickUpLocation = jsonData['pickup_location'];
        dropOffLocation = jsonData['drop_off_location'];
        pickUpTime = jsonData['pick_up_time'];
        startDate = jsonData['start_date'];
        status = jsonData['status'];
        dateRequested = jsonData['date_scheduled'];
        timeRequested = jsonData['time_scheduled'];
        price = jsonData['price'];
        charge = jsonData['charge'];
        passengerId = jsonData['passenger'].toString();
        passengerPhoneNumber = jsonData['get_passenger_number'];
        scheduleRideId = jsonData['id'].toString();
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
//
  Future<void> getActiveSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_drives_assigned_and_active_schedules/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        activeSchedules.assignAll(jsonData);

        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_drives_assigned_schedules/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allSchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  //drivers schedules by types
  Future<void> getDriversOneTimeSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_scheduled_for_one_time/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allOneTimeSchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getDriversDailySchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_scheduled_for_daily/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDailySchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getDriversDaysSchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_scheduled_for_days/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDaysSchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getDriversWeeklySchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_scheduled_for_days/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allWeeklySchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getDriversMonthlySchedules(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_scheduled_for_monthly/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allMonthlySchedules.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  driverAlertPassenger(String passenger) async {
    const requestUrl = "https://taxinetghana.xyz/driver_alert_passenger/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "passenger": passenger,

    });
    if (response.statusCode == 201) {
      Get.snackbar("Hurray 😀", "passenger has been alerted",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
    }
    else{
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }

  driverStartTrip(String passenger, String rideTitle) async {
    const requestUrl = "https://taxinetghana.xyz/driver_start_trip/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "passenger": passenger,
      "ride": rideTitle,
    });
    if (response.statusCode == 201) {
      rideStarted = true;
      Get.snackbar("Hurray 😀", "you have started trip",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
      update();
    }
    else{
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }

  driverEndTrip(String passenger, String rideTitle,String price,String pMethod) async {
    const requestUrl = "https://taxinetghana.xyz/driver_end_trip/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "passenger": passenger,
      "ride": rideTitle,
      "price": price,
      "payment_method": pMethod,
    });
    if (response.statusCode == 201) {
      rideStarted = false;
      update();
      Get.snackbar("Hurray 😀", "you have ended the trip",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5));
    }
    else{
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
    }
  }

  updateRide(String passenger, String rideId)async {
    final requestUrl = "https://taxinetghana.xyz/update_requested_ride/$rideId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "passenger": passenger,
      "ride": rideId,
      "completed": "True",
    });
    if(response.statusCode == 200){}
    else{}
  }
}