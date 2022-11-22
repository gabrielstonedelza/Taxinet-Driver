import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taxinet_driver/driver/home/pages/driverHome.dart';
import '../../bottomnavigation.dart';
import '../../constants/app_colors.dart';
import '../../controllers/commissioncontroller.dart';
import '../../controllers/walletcontroller.dart';
import 'package:http/http.dart' as http;

import '../../g_controllers/user/user_controller.dart';

class ActivateExtra extends StatefulWidget {

  const ActivateExtra({Key? key}) : super(key: key);

  @override
  State<ActivateExtra> createState() => _ActivateExtraState();
}

class _ActivateExtraState extends State<ActivateExtra> {
  final CommissionController commissionController = Get.find();
  final WalletController walletController = Get.find();
  final UserController userController = Get.find();
  double initialWallet = 0;
  double commissionBalance = 0;
  String driver = "";
  var uToken = "";
  final storage = GetStorage();
  var username = "";


  updateWallet()async {
    final requestUrl = "https://taxinetghana.xyz/user_update_wallet/${walletController.walletId}/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "amount" : initialWallet.toString(),
      "user" : userController.driverProfileId,
      "id": walletController.walletId
    });
    if(response.statusCode == 200){

      Get.snackbar("Success", "wallet was updated",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
    }
    else{
      if (kDebugMode) {
        // print(response.body);
      }
    }
  }

  @override
  void initState(){
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    setState(() {
      driver = commissionController.driver;
      initialWallet = double.parse(walletController.wallet);
    });
  }


  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: const [
              Text("Activate Extra Time"),
            ],
          ),
          backgroundColor:primaryColor,
        ),
        // backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text("Are you sure you want to activate extra time?",style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    initialWallet = initialWallet - 50;
                    updateWallet();
                    Get.offAll(() => const MyBottomNavigationBar());
                  },
                  // child: const Text("Send"),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          8)),
                  elevation: 8,
                  fillColor:
                  primaryColor,
                  splashColor:
                  defaultColor,
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                        fontWeight:
                        FontWeight
                            .bold,
                        fontSize: 20,
                        color:
                        defaultTextColor1),
                  ),
                ),
                const SizedBox(width:20),
                RawMaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  // child: const Text("Send"),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          8)),
                  elevation: 8,
                  fillColor:
                  Colors.red,
                  splashColor:
                  defaultColor,
                  child: const Text(
                    "No",
                    style: TextStyle(
                        fontWeight:
                        FontWeight
                            .bold,
                        fontSize: 20,
                        color:
                        defaultTextColor1),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}
