import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:taxinet_driver/driver/home/transfers/wallettodriver.dart';
import 'package:taxinet_driver/driver/home/transfers/wallettopassenger.dart';


import '../../../constants/app_colors.dart';

class Transfers extends StatefulWidget {
  const Transfers({Key? key}) : super(key: key);

  @override
  State<Transfers> createState() => _TransfersState();
}

class _TransfersState extends State<Transfers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Wallet Transfers",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black)),
          backgroundColor:Colors.transparent,
          elevation:0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body:ListView(
          children: [
            const SizedBox(height:30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=> const SendFromWalletToPassenger());
                          },
                          child: Container(
                              width:120,
                              height:120,
                              decoration: BoxDecoration(
                                  color: pearl,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black)]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Image.asset("assets/images/wallet.png",width:90,height:90),
                              )
                          ),
                        ),
                        const SizedBox(height:20),
                        const Text("To passenger",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [

                        GestureDetector(
                          onTap: (){
                            Get.to(()=> const SendFromWalletToDriver());
                          },
                          child: Container(
                              width:120,
                              height:120,
                              decoration: BoxDecoration(
                                  color: pearl,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.black)]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Image.asset("assets/images/wallet.png",width:90,height:90),
                              )
                          ),
                        ),
                        const SizedBox(height:20),
                        const Text("To driver",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
                      ],
                    ),
                  )
                ],
              ),
            )

          ],
        )
    );
  }
}
