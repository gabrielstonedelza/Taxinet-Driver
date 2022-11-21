import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import "package:get/get.dart";
import '../../constants/app_colors.dart';
import '../../controllers/bonuscontroller.dart';
import '../../controllers/walletcontroller.dart';
import '../../g_controllers/user/user_controller.dart';
import 'package:http/http.dart' as http;

class MyBonuses extends StatefulWidget {

  const MyBonuses({Key? key}) : super(key: key);

  @override
  State<MyBonuses> createState() => _MyBonusesState();
}

class _MyBonusesState extends State<MyBonuses> {
  final WalletController walletController = Get.find();
  final UserController userController = Get.find();
  final BonusController bonusesController = Get.find();
  double initialWallet = 0;
  double commissionBalance = 0;
  var items;
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
      "user" : driver,
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

  resetCommission() async {
    final requestUrl = "https://taxinetghana.xyz/user_bonus_delete/$driver/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.delete(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
    }, body: {
      "driver" : driver,
    });
    if(response.statusCode == 204){
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
      driver = bonusesController.driver;
      initialWallet = double.parse(walletController.wallet);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Bonuses"),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<BonusController>(builder:(salaryController){
          return ListView.builder(
              itemCount: salaryController.myBonuses != null ? salaryController.myBonuses.length : 0,
              itemBuilder: (context,index){
                items = salaryController.myBonuses[index];
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
        floatingActionButton:FloatingActionButton(
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
                                      const Text("Bonus Total: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(bonusesController.totalBonuses.toString(),style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )
                              ),
                              const SizedBox(height:10),
                              const Center(
                                  child: Text("Are you sure you want to transfer your bonus to your wallet?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                              ),
                              const SizedBox(height:20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      initialWallet = initialWallet + bonusesController.totalBonuses;
                                      updateWallet();
                                      resetCommission();
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
