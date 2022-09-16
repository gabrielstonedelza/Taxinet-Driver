import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class InventoryController extends GetxController{
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";

  List inventories = [];
  String driversPic = "";
  String driversName = "";
  String registrationNumber= "";
  String uniqueNumber= "";
  String vehicleBrand= "";
  String millage= "";
  String windscreen= "";
  String sideMirror= "";
  String registrationPlate= "";
  String tirePressure= "";
  String drivingMirror= "";
  String tireThreadDepth= "";
  String wheelNuts= "";
  String engineOil= "";
  String fuelLevel= "";
  String breakFluid= "";
  String radiatorEngineCoolant= "";
  String powerSteeringFluid= "";
  String wiperWasherFluid= "";
  String seatBelts= "";
  String steeringWheel= "";
  String horn= "";
  String electricWindows= "";
  String windscreenWipers= "";
  String headLights= "";
  String trafficators= "";
  String tailRearLights= "";
  String reverseLights= "";
  String interiorLights= "";
  String engineNoise= "";
  String excessiveSmoke= "";
  String footBreak= "";
  String handBreak= "";
  String wheelBearingNoise= "";
  String warningTriangle= "";
  String fireExtinguisher= "";
  String firstAidBox= "";
  late bool checkedToday;
  String dateChecked= "";
  String timeChecked= "";

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
    getAllInventories();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getAllInventories();
      update();
    });
  }

  Future<void> getAllInventories() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_driver_inventory/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        inventories.assignAll(jsonData);
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

  Future<void> getDetailInventory(String id) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/driver_inventory_details/$id/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $uToken"
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        driversPic = jsonData['get_driver_profile_pic'];
        driversName = jsonData['get_drivers_name'];
        registrationNumber = jsonData['registration_number'];
        uniqueNumber = jsonData['unique_number'];
        vehicleBrand = jsonData['vehicle_brand'];
        millage = jsonData['millage'];
        windscreen = jsonData['windscreen'];
        sideMirror = jsonData['side_mirror'];
        registrationPlate = jsonData['registration_plate'];
        tirePressure = jsonData['tire_pressure'];
        drivingMirror = jsonData['driving_mirror'];
        tireThreadDepth = jsonData['tire_thread_depth'];
        wheelNuts = jsonData['wheel_nuts'];
        engineOil = jsonData['engine_oil'];
        fuelLevel = jsonData['fuel_level'];
        breakFluid = jsonData['break_fluid'];
        radiatorEngineCoolant = jsonData['radiator_engine_coolant'];
        powerSteeringFluid = jsonData['power_steering_fluid'];
        wiperWasherFluid = jsonData['wiper_washer_fluid'];
        seatBelts = jsonData['seat_belts'];
        steeringWheel = jsonData['steering_wheel'];
        horn = jsonData['horn'];
        electricWindows = jsonData['electric_windows'];
        windscreenWipers = jsonData['windscreen_wipers'];
        headLights = jsonData['head_lights'];
        trafficators = jsonData['trafficators'];
        tailRearLights = jsonData['tail_rear_lights'];
        reverseLights = jsonData['reverse_lights'];
        interiorLights = jsonData['interior_lights'];
        engineNoise = jsonData['engine_noise'];
        excessiveSmoke = jsonData['excessive_smoke'];
        footBreak = jsonData['foot_break'];
        handBreak = jsonData['hand_break'];
        wheelBearingNoise = jsonData['wheel_bearing_noise'];
        warningTriangle = jsonData['warning_triangle'];
        fireExtinguisher = jsonData['fire_extinguisher'];
        firstAidBox = jsonData['first_aid_box'];
        checkedToday = jsonData['checked_today'];
        dateChecked = jsonData['date_checked'];
        timeChecked = jsonData['time_checked'];

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