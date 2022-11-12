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
  late List passengerUserNames = [];
  late List driversUniqueCodes = [];
  late List allDrivers = [];
  late List driversNames = [];
  late List passengerNames = [];
  late List passengersUniqueCodes = [];
  late List allPassengers = [];

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
    // getUserProfile();
    // getAllDrivers();
    // getAllPassengers();
    // _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   getUserProfile();
    //   getAllDrivers();
    //   getAllPassengers();
    //   update();
    // });
  }

  File? profileImageUpload;
  File? frontCard;
  File? backCard;

  Future<void> getAllDrivers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_drivers_profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers = jsonData;
        for (var i in allDrivers) {
          if(!driversUniqueCodes.contains(i['unique_code'])){
            driversUniqueCodes.add(i['unique_code']);
          }
          if(!driversNames.contains(i['get_drivers_full_name'])){
            driversNames.add(i['get_drivers_full_name']);
          }
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

  Future<void> getAllPassengers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_passengers_profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allPassengers = jsonData;
        for (var i in allPassengers) {
          if(!passengersUniqueCodes.contains(i['unique_code'])){
            passengersUniqueCodes.add(i['unique_code']);
          }
          if(!passengerNames.contains(i['get_passengers_full_name'])){
            passengerNames.add(i['get_passengers_full_name']);
          }
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


  Future getFromGalleryForProfilePic() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    _cropImageProfilePic(pickedFile!.path);
  }

  Future getFromGalleryForFrontCard() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    _cropImageFrontCard(pickedFile!.path);
  }

  Future getFromGalleryForBackCard() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
    _cropImageForBackCard(pickedFile!.path);
  }

  Future getFromCameraForProfilePic() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    _cropImageProfilePic(pickedFile!.path);
  }

  Future getFromCameraForFrontCard() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    _cropImageFrontCard(pickedFile!.path);
  }

  Future getFromCameraForBackCard() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 1080, maxWidth: 1080);
    _cropImageForBackCard(pickedFile!.path);
  }

  Future _cropImageProfilePic(filePath) async {
    File? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      profileImageUpload = croppedImage;
      _uploadAndUpdateProfilePic(profileImageUpload!);
      // getUserProfile();
      update();
    }
  }

  Future _cropImageForBackCard(filePath) async {
    File? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      backCard = croppedImage;
      _uploadAndUpdateBackCard(backCard!);
      update();
      hasUploadedBackCard = true;
    }
  }

  Future _cropImageFrontCard(filePath) async {
    File? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      frontCard = croppedImage;
      _uploadAndUpdateFrontCard(frontCard!);
      update();
      hasUploadedFrontCard = true;
    }
  }

  void _uploadAndUpdateProfilePic(File file) async {
    try {
      isUpdating = true;
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'profile_pic':
        await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_driver_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", response.data.toString(),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "Your profile picture was updated",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", "something went wrong,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    } finally {
      isUpdating = false;
    }
  }

  void _uploadAndUpdateFrontCard(File file) async {
    try {
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'front_side_ghana_card':
        await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_passenger_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", "Something happened. Please try again later",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "card uploaded successfully,you will be notified when verified.",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", "Something happened. Please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
    }
  }

  void _uploadAndUpdateBackCard(File file) async {
    try {
      //updating user profile details
      String fileName = file.path.split('/').last;
      var formData1 = FormData.fromMap({
        'back_side_ghana_card':
        await MultipartFile.fromFile(file.path, filename: fileName),
      });
      var response = await dio.put(
        'https://taxinetghana.xyz/update_passenger_profile/',
        data: formData1,
        options: Options(headers: {
          "Authorization": "Token $uToken",
          "HttpHeaders.acceptHeader": "accept: application/json",
        }, contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode != 200) {
        Get.snackbar("Sorry", "something happened,please try again later",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Hurray 😀", "card uploaded successfully,you will be notified when verified.",
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 5));
      }
    } on DioError catch (e) {
      Get.snackbar("Sorry", "something happened,please try again later",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red);
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
          uniqueCode = i['unique_code'];
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

}
