import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RidesController extends GetxController{
  static RidesController get to => Get.find<RidesController>();
  late List allNotifications = [];
  late List driversCompletedRides = [];
  bool isLoading = true;
  final storage = GetStorage();

  Future<void> getDriversRidesCompleted() async {
    try {
      isLoading = true;
      const completedRides =
          "https://taxinetghana.xyz/drivers_requests_completed";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token ${storage.read("userToken")}"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        driversCompletedRides.assignAll(jsonData);

      } else {
        Get.snackbar("Sorry", "please check your internet connection");
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      isLoading = false;
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDriversRidesCompleted();
  }

}