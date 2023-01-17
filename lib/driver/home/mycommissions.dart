import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../constants/app_colors.dart';
import '../../controllers/commissioncontroller.dart';
import '../../controllers/walletcontroller.dart';
import 'package:http/http.dart' as http;

import '../../g_controllers/user/user_controller.dart';

class MyCommissions extends StatefulWidget {

  const MyCommissions({Key? key}) : super(key: key);

  @override
  State<MyCommissions> createState() => _MyCommissionsState();
}

class _MyCommissionsState extends State<MyCommissions> {
  final CommissionController commissionController = Get.find();
  final WalletController walletController = Get.find();
  final UserController userController = Get.find();
  double initialWallet = 0;
  double commissionBalance = 0;
  String driver = "";


  updateWallet()async {
    final requestUrl = "https://taxinetghana.xyz/admin_update_wallet/${walletController.walletId}/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      // "Authorization": "Token $uToken"
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
        print(response.body);
      }
    }
  }

  resetCommission()async {
    final requestUrl = "https://taxinetghana.xyz/user_commissions_delete/$driver/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.delete(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
    }, body: {
      "driver" : userController.driverProfileId,
    });
    if(response.statusCode == 200){
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
  }


  transferCommission()async {
    const  requestUrl = "https://taxinetghana.xyz/driver_commission_to_wallet/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      // "Authorization": "Token $uToken"
    }, body: {
      "driver": userController.driverProfileId,
      "amount": commissionController.totalCommissions.toString(),
    });
    if(response.statusCode == 201){

      initialWallet = initialWallet + commissionController.totalCommissions;
      updateWallet();
      resetCommission();

      Get.snackbar("Success", "Transfer was completed",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void initState(){
    super.initState();
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
              Text("Commissions"),
            ],
          ),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<CommissionController>(builder:(controller){
          return ListView.builder(
              itemCount: controller.myCommission != null ? controller.myCommission.length : 0,
              itemBuilder: (context,index){
                items = controller.myCommission[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,),
                  child: SlideInUp(
                    animate: true,
                    child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            leading: const Icon(Icons.access_time_filled),
                            title: Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text("₵${items['amount']}",style:const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text(items['date_paid']),
                                  ),
                                  Text(items['time_paid'].toString().split(".").first),
                                ],
                              ),
                            )
                        )
                    ),
                  ),
                );
              }
          );
        }),
      floatingActionButton:commissionController.myCommission.isEmpty ? Container() : FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.vertical(
                    top: Radius.circular(25.0))),
            bounce: true,
            builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: SizedBox(
                  height: 200,
                  child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: ListView(
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Commission Total: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(commissionController.totalCommissions.toString(),style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )
                          ),
                          const SizedBox(height:10),
                          const Center(
                              child: Text("Are you sure you want to transfer your commission to your wallet?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                          ),
                          const SizedBox(height:20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  transferCommission();
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
                  )
              ),
            ),
          );
        },
        child : Image.asset("assets/images/money-withdrawal.png",width:40,height:40,fit:BoxFit.cover)
      )
    );
  }
}
