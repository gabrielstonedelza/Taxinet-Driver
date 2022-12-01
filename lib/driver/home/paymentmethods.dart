import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import '../../constants/app_colors.dart';
import 'package:http/http.dart' as http;

import '../../g_controller/userController.dart';
import '../../views/bottomnavigationbar.dart';

class PaymentMethods extends StatefulWidget {
  String amount;
  PaymentMethods({Key? key,required this.amount}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState(amount:this.amount);
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String amount;
  List paymentOptions =[
    "Select Payment Option",
    "Mobile Money",
    "Ecobank",
  ];
  String _currentSelectedPaymentOption = "Select Payment Option";
  String message = "";
  String message2 = "";
  late final TextEditingController transactionIdController;
  late final TextEditingController amountController;
  final _formKey = GlobalKey<FormState>();
  final FocusNode transId = FocusNode();
  UserController userController = Get.find();

  bool isPosting = false;
  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  var uToken = "";
  final storage = GetStorage();
  var username = "";
  bool isMobileMoney = false;
  bool isEcoBank = false;

  requestTopUp() async {
    const requestUrl = "https://taxinetghana.xyz/request_top_up/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    }, body: {
      "user": userController.passengerProfileId,
      "amount": amountController.text,
      "top_up_option": _currentSelectedPaymentOption,
      "transaction_id": transactionIdController.text,
    });
    if (response.statusCode == 201) {
      Get.snackbar("Success 😀", "request sent.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor1);
      setState(() {
        transactionIdController.text = "";
        _currentSelectedPaymentOption = "Select Payment Option";
        amountController.text = "";
      });
      Get.offAll(() => const MyBottomNavigationBar());
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
      Get.snackbar("Sorry 😢", "something went wrong,please try again later.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
    }
  }

  @override
  void initState(){
    super.initState();
    transactionIdController = TextEditingController();
    amountController = TextEditingController();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
  }

  _PaymentMethodsState({required this.amount});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // backgroundColor: primaryColor,
            appBar: AppBar(
              title: const Text("Continue Top Up",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.black)),
              backgroundColor:Colors.transparent,
              elevation:0,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left:18.0,right: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height:10),
                    Center(
                        child: Text("Paying GHS $amount",style: const TextStyle(fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(height:10),
                    TextFormField(
                      controller: amountController..text = amount,
                      focusNode: transId,
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText:
                          "Amount",
                          labelStyle:
                          const TextStyle(
                              color:
                              muted),
                          focusColor:
                          muted,
                          fillColor:
                          muted,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color:
                                  muted,
                                  width:
                                  2),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(12))),
                      // cursorColor: Colors.black,
                      // style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            items: paymentOptions.map((dropDownStringItem) {
                              return DropdownMenuItem(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              _onDropDownItemSelectedPaymentMethod(newValueSelected);
                              if(newValueSelected == "Mobile Money"){
                                setState(() {
                                  isMobileMoney = true;
                                  isEcoBank = false;
                                  message = "Please send mobile money to 0244950505,get transaction id,enter transaction id below to continue.";
                                });
                              }
                              if(newValueSelected == "Ecobank"){
                                setState(() {
                                  isMobileMoney = false;
                                  isEcoBank = true;
                                  message = "Please send from your Xpress accounts to Taxinet Logistics account(1441002567287),get the transaction id and complete the form.";
                                });
                              }
                              // else{
                              //   setState(() {
                              //     message = "";
                              //     isMobileMoney = false;
                              //   });
                              // }
                            },
                            value: _currentSelectedPaymentOption,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: transactionIdController,
                      focusNode: transId,
                      decoration: InputDecoration(

                          labelText:
                          "Transaction Id",
                          labelStyle:
                          const TextStyle(
                              color:
                              muted),
                          focusColor:
                          muted,
                          fillColor:
                          muted,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color:
                                  muted,
                                  width:
                                  2),
                              borderRadius:
                              BorderRadius.circular(
                                  12)),
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(12))),
                      // cursorColor: Colors.black,
                      // style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Transaction Id";
                        }
                        else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height:20),
                    isPosting ? const Center(
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 5,
                        backgroundColor: primaryColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black
                        ),
                      ),
                    ):
                    RawMaterialButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        _startPosting();
                        if (_formKey.currentState!.validate()) {
                          if(_currentSelectedPaymentOption == "Select Payment Option"){
                            Get.snackbar("Payment Error", "please select a payment option",
                                colorText: defaultTextColor1,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red
                            );
                          }
                          requestTopUp();
                        } else {
                          Get.snackbar("Error", "Something went wrong",
                              colorText: defaultTextColor1,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red
                          );
                          return;
                        }
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
                        "Top Up",
                        style: TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height:20),
                    isMobileMoney ? SlideInUp(
                      animate: true,
                      child: Center(
                          child: Text(message,style: const TextStyle(fontWeight: FontWeight.bold))
                      ),
                    ) : Container(),const SizedBox(height:20),
                    isEcoBank ? SlideInUp(
                      animate: true,
                      child: Center(
                          child: Text(message,style: const TextStyle(fontWeight: FontWeight.bold))
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            )
        )
    );
  }

  void _onDropDownItemSelectedPaymentMethod(newValueSelected) {
    setState(() {
      _currentSelectedPaymentOption = newValueSelected;
    });
  }
}
