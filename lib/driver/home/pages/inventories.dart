import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/inventorycontroller.dart';
import "package:get/get.dart";

import '../../../controllers/walletcontroller.dart';
import '../addinventory.dart';
import '../inventorydetail.dart';

class Inventories extends StatefulWidget {
  const Inventories({Key? key}) : super(key: key);

  @override
  State<Inventories> createState() => _InventoriesState();
}

class _InventoriesState extends State<Inventories> {
  InventoryController controller = Get.find();
  var items;
  WalletController walletController = Get.find();
  double amountToPay = 70.0;
  bool canPayToday = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(double.parse(walletController.wallet) >= amountToPay){
      setState(() {
        canPayToday = true;
      });
    }
    else{
      setState(() {
        canPayToday = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:primaryColor,
        title: const Text("Inventories"),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.circlePlus,size:30),
            onPressed: (){
              canPayToday ?
              Get.to(()=> const AddInventory()) : Get.snackbar("Sorry 😭", "your wallet is low,please load wallet.",
                  duration: const Duration(seconds: 8),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: defaultTextColor1);
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: controller.inventories != null ? controller.inventories.length :0,
          itemBuilder: (context,index){
            items = controller.inventories[index];
            return Column(
              children: [
                const SizedBox(height: 10,),
                SlideInUp(
                  animate: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18,right: 18),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:ListTile(
                        onTap: (){
                          Get.to(()=> InventoryDetail(id:controller.inventories[index]['id'].toString(),date_checked:controller.inventories[index]['date_checked']));
                        },
                        leading: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.assessment)
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Text(items['date_checked']),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(items['time_checked'].toString().split(".").first),
                        ),
                      )
                    ),
                  ),
                )
              ],
            );

          }
      ),
    );
  }
}
