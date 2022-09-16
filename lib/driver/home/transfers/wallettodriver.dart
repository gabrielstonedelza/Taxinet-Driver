import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import "package:get/get.dart";
import '../../../constants/app_colors.dart';

import '../../../g_controllers/user/user_controller.dart';
import '../../../widgets/shimmers/shimmerwidget.dart';
import 'package:http/http.dart' as http;

class SendFromWalletToDriver extends StatefulWidget {
  const SendFromWalletToDriver({Key? key}) : super(key: key);

  @override
  State<SendFromWalletToDriver> createState() => _SendFromWalletToDriverState();
}

class _SendFromWalletToDriverState extends State<SendFromWalletToDriver> {
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  final TextEditingController _driverUniqueCode = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserController userController = Get.find();
  bool isDriversCode = false;
  late List driversDetails = [];
  String driversName = "";
  String driversPicture = "";
  String driverId = "";
  bool isLoading = true;
  bool isPosting = false;
  late double sendersWallet = 0.0;
  late double receiversWallet = 0.0;
  late double currentAmountForSender = 0.0;
  late double currentAmountForReceiver = 0.0;
  bool amountHasValue = false;
  String amountError = "";
  bool amountGreaterThanBalance = false;
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  Future<void> getDriverProfile(String uniqueCode) async {
    final profileLink =
        "https://taxinetghana.xyz/get_drivers_profile_by_unique_code/$uniqueCode/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);
      driversName = jsonData['get_drivers_full_name'];
      driversPicture = jsonData['driver_profile_pic'];
      driverId = jsonData['user'].toString();
      getReceiversWallet();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  //get user transferring to other wallet's amount and the other user receiving wallet amount
  //get wallet detail for sender
  Future<void> getSendersWallet() async {
    final profileLink =
        "https://taxinetghana.xyz/get_wallet_by_user/${userController.driverProfileId}/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);

      setState(() {
        sendersWallet = double.parse(jsonData['amount']);
      });
    } else {
      if (kDebugMode) {
        print("This is error is coming from senders wallet ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  //get wallet detail for Receiver
  Future<void> getReceiversWallet() async {
    final profileLink =
        "https://taxinetghana.xyz/get_wallet_by_user/$driverId/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);
      setState(() {
        receiversWallet = double.parse(jsonData['amount']);
      });
    } else {
      if (kDebugMode) {
        print("This is error is coming from receiversWallet ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  processWalletTransfer() async {
    const depositUrl = "https://taxinetghana.xyz/transfer_to_wallet/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "sender": userController.driverProfileId,
      "receiver": driverId,
      "amount": _amountController.text.trim(),
    });
    if (res.statusCode == 201) {
      Get.snackbar("Hurray 😀", "Transaction completed successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      processUpdateSendersWallet();
      processUpdateReceiversWallet();
      setState(() {
        _amountController.text = "";
        _driverUniqueCode.text = "";
        isDriversCode = false;
        amountGreaterThanBalance = false;
        amountHasValue = false;
      });
      // Get.offAll(()=> const MyBottomNavigationBar());
    }
  }

  //update senders wallet
  processUpdateSendersWallet() async {
    final depositUrl =
        "https://taxinetghana.xyz/user_update_wallet/${userController.driverProfileId}/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "user": userController.driverProfileId,
      "amount": currentAmountForSender.toString(),
    });
    if (res.statusCode == 200) {
      Get.snackbar("Hurray 😀", "Transaction completed successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
    }
  }

  //update receivers wallet
  processUpdateReceiversWallet() async {
    final depositUrl = "https://taxinetghana.xyz/user_update_wallet/$driverId/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "user": driverId,
      "amount": currentAmountForReceiver.toString(),
    });
    if (res.statusCode == 200) {
      Get.snackbar("Hurray 😀", "Transaction completed successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      // Get.to(()=> const Transfers());
    }
  }

  @override
  void initState() {
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    userController.getAllDrivers();
    getSendersWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Transfer to wallet"),
            backgroundColor: primaryColor),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            if(value.length == 8 && value == userController.uniqueCode){
                              Get.snackbar("Transfer Error",
                                  "You cannot transfer to yourself",
                                  colorText: defaultTextColor1,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5));
                              setState(() {
                                isDriversCode = false;
                              });
                            }
                            else{
                              if (value.length == 8 &&
                                  userController.driversUniqueCodes
                                      .contains(value)) {
                                setState(() {
                                  isDriversCode = true;
                                });
                                getDriverProfile(_driverUniqueCode.text.trim());
                              } else if (value.length == 8 &&
                                  !userController.driversUniqueCodes
                                      .contains(value)) {
                                Get.snackbar("Driver Error",
                                    "can't find driver with unique code",
                                    colorText: defaultTextColor1,
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 5));
                                setState(() {
                                  isDriversCode = false;
                                });
                              }
                            }

                          },
                          controller: _driverUniqueCode,
                          cursorRadius: const Radius.elliptical(3, 3),
                          cursorWidth: 3,
                          cursorColor: defaultBlack,
                          decoration: const InputDecoration(
                            labelText: "Enter drivers unique code",
                            labelStyle: TextStyle(color: secondaryColor),
                            focusColor: primaryColor,
                            fillColor: primaryColor,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter drivers unique code";
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                double.parse(_amountController.text) >
                                    sendersWallet) {
                              setState(() {
                                amountGreaterThanBalance = true;
                                amountHasValue = false;
                                amountError =
                                "Your balance is less than what you are trying to send";
                              });
                            } else {
                              setState(() {
                                amountGreaterThanBalance = false;
                                amountHasValue = true;
                                amountError = "";
                              });
                            }
                            if (value.isNotEmpty) {
                              setState(() {
                                amountHasValue = true;
                              });
                            } else {
                              setState(() {
                                amountHasValue = false;
                              });
                            }
                          },
                          controller: _amountController,
                          // cursorColor:
                          // primaryColor,
                          cursorRadius: const Radius.elliptical(3, 3),
                          cursorWidth: 3,
                          cursorColor: defaultBlack,
                          decoration: const InputDecoration(
                            labelText: "Enter amount",
                            labelStyle: TextStyle(color: secondaryColor),
                            focusColor: primaryColor,
                            fillColor: primaryColor,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter amount";
                            }
                          },
                        ),
                      ),
                      amountGreaterThanBalance
                          ? Center(
                          child: Text(amountError,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)))
                          : Container(),
                      const SizedBox(height: 20),
                      !isPosting &&
                          isDriversCode &&
                          amountHasValue &&
                          !amountGreaterThanBalance
                          ? RawMaterialButton(
                        onPressed: () {
                          _startPosting();
                          if (_formKey.currentState!.validate()) {
                            processWalletTransfer();
                            setState(() {
                              currentAmountForSender = sendersWallet -
                                  double.parse(
                                      _amountController.text.trim());
                              currentAmountForReceiver = receiversWallet +
                                  double.parse(
                                      _amountController.text.trim());
                            });
                          }
                        },
                        // child: const Text("Send"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 8,
                        fillColor: defaultBlack,
                        splashColor: defaultColor,
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: defaultTextColor1),
                        ),
                      )
                          : Container(),
                      const SizedBox(height: 20),
                      isDriversCode
                          ? SlideInUp(
                        animate: true,
                        child: Card(
                            elevation: 12,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0))),
                            child: SizedBox(
                              width: 300,
                              height: 150,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: isLoading
                                        ? const ShimmerWidget.circular(
                                        width: 100, height: 100)
                                        : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          driversPicture),
                                      radius: 40,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(driversName,
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold)))
                                ],
                              ),
                            )),
                      )
                          : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
