import "package:flutter/material.dart";
import "package:get/get.dart";
import '../../constants/app_colors.dart';

class PaymentMethods extends StatefulWidget {
  String amount;
  PaymentMethods({Key? key,required this.amount}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState(amount:this.amount);
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String amount;
  _PaymentMethodsState({required this.amount});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              title: const Text("Select payment method",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black)),
              backgroundColor:Colors.transparent,
              elevation:0,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height:10),
                Center(
                    child: Text("Paying GHS $amount",style: const TextStyle(fontWeight: FontWeight.bold))
                ),
                const SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.defaultDialog(
                              buttonColor: primaryColor,
                              middleTextStyle: const TextStyle(fontSize: 12),
                              titleStyle: const TextStyle(fontSize: 15),
                              title: "Call Office",
                              content: const Text("Please kindly call 0244950505 to get your wallet loaded.")
                          );
                        },
                        child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                color: defaultBlack,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [BoxShadow(offset:Offset(0,4), blurRadius:4,color:Colors.white38)]
                            ),child: const Center(child: Text("Load by office",style: TextStyle(fontWeight: FontWeight.bold,color:defaultTextColor1)))),
                      ),
                      const SizedBox(height:30),

                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}
