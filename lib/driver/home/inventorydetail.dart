import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";

import '../../constants/app_colors.dart';
import '../../controllers/inventorycontroller.dart';

class InventoryDetail extends StatefulWidget {
  String id;
  String date_checked;
  InventoryDetail({Key? key,required this.id, required this.date_checked}) : super(key: key);

  @override
  State<InventoryDetail> createState() => _InventoryDetailState(id:this.id,date_checked:this.date_checked);
}

class _InventoryDetailState extends State<InventoryDetail> {
  String id;
  String date_checked;
  _InventoryDetailState({required this.id,required this.date_checked});
  InventoryController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getDetailInventory(id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(date_checked,style:const TextStyle(color: defaultTextColor2)),
            centerTitle: true,
            backgroundColor:Colors.transparent,
            elevation:0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
            ),
          ),
        body: ListView(
          children: [
            const SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.only(left:15,right:15,),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GetBuilder<InventoryController>(
                            builder: (controller) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    controller.
                                    driversPic),
                                radius: 30,
                              );
                            },
                          ),
                          const SizedBox(width: 20,),
                          GetBuilder<InventoryController>(builder: (controller) {
                            return Text(controller.driversName,style:const TextStyle(fontWeight: FontWeight.bold));
                          })
                        ],
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Millage",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.millage);
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Windscreen",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.windscreen,style:TextStyle(color:controller.windscreen == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Side Mirror",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.sideMirror,style:TextStyle(color:controller.sideMirror == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Registration Plate",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.registrationPlate,style:TextStyle(color:controller.registrationPlate == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tire Pressure",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.tirePressure,style:TextStyle(color:controller.tirePressure == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Driving Mirror",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.drivingMirror,style:TextStyle(color:controller.drivingMirror == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tire thread depth",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.tireThreadDepth,style:TextStyle(color:controller.tireThreadDepth == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("WheelNuts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.wheelNuts,style:TextStyle(color:controller.wheelNuts == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Engine Oil",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.engineOil,style:TextStyle(color:controller.engineOil == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Fuel Oil",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.fuelLevel,style:TextStyle(color:controller.fuelLevel == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Break Fluid",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.breakFluid,style:TextStyle(color:controller.breakFluid == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Radiator engine coolant",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.radiatorEngineCoolant,style:TextStyle(color:controller.radiatorEngineCoolant == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Power steering fluid",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.powerSteeringFluid,style:TextStyle(color:controller.powerSteeringFluid == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Wiper washer fluid",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.wiperWasherFluid,style:TextStyle(color:controller.wiperWasherFluid == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("SeatBelts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.seatBelts,style:TextStyle(color:controller.seatBelts == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Steering wheel",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.steeringWheel,style:TextStyle(color:controller.steeringWheel == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Horn",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.horn,style:TextStyle(color:controller.horn == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Electric windows",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.electricWindows,style:TextStyle(color:controller.electricWindows == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Windscreen wipers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.windscreenWipers,style:TextStyle(color:controller.windscreenWipers == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Head lights",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.headLights,style:TextStyle(color:controller.headLights == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Trafficators",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.trafficators,style:TextStyle(color:controller.trafficators == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Tail rear lights",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.tailRearLights,style:TextStyle(color:controller.tailRearLights == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Reverse lights",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.reverseLights,style:TextStyle(color:controller.reverseLights == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Interior lights",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.interiorLights,style:TextStyle(color:controller.interiorLights == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Engine noise",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.engineNoise,style:TextStyle(color:controller.engineNoise == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Excessive smoke",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.excessiveSmoke,style:TextStyle(color:controller.excessiveSmoke == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Foot break",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.footBreak,style:TextStyle(color:controller.footBreak == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hand break",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.handBreak,style:TextStyle(color:controller.handBreak == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Wheel bearing noise",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.wheelBearingNoise,style:TextStyle(color:controller.wheelBearingNoise == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Warning triangle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.warningTriangle,style:TextStyle(color:controller.warningTriangle == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Fire extinguisher",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.fireExtinguisher,style:TextStyle(color:controller.fireExtinguisher == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                      const SizedBox(height:10),
                      const Divider(),
                      const SizedBox(height:10),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("First aid box",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            const SizedBox(height:10),
                            GetBuilder<InventoryController>(builder: (controller) {
                              return Text(controller.firstAidBox,style:TextStyle(color:controller.firstAidBox == "okay"?Colors.green:Colors.red,fontWeight: FontWeight.bold));
                            })
                          ]
                      ),
                    ],
                  )
                )
              ),
            ),
            const SizedBox(height:20),
          ],
        )
      )
    );
  }
}
