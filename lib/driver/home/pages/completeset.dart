import "package:flutter/material.dart";
import "package:get/get.dart";

import '../../../constants/app_colors.dart';
import '../../../g_controllers/user/user_controller.dart';


class CompleteSetUp extends StatefulWidget {
  const CompleteSetUp({Key? key}) : super(key: key);

  @override
  State<CompleteSetUp> createState() => _CompleteSetUpState();
}

class _CompleteSetUpState extends State<CompleteSetUp> {
  UserController userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  TextEditingController referralController = TextEditingController();
  bool isPosting = false;

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
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
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const Center(
                child: Text("Complete Setup",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
            ),
            const SizedBox(height: 20),
            const Center(child: Text("You need to upload your Ghana to complete your account verification")),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                !userController.verified ? Get.defaultDialog(
                    buttonColor: primaryColor,
                    middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    title: "Select front side of card",
                    content: Row(
                      children: [

                      ],
                    )
                ) : Get.defaultDialog(
                    buttonColor: primaryColor,
                    middleTextStyle: const TextStyle(fontSize: 12),
                    titleStyle: const TextStyle(fontSize: 15),
                    title: "😀 Success",
                    content: const Center(
                        child: Text("Your account is already verified.")
                    )
                );
              },
              child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset("assets/images/id-card.png",width: 30,height: 30,),
                            !userController.verified ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.red
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Not Verified",style:TextStyle(color:Colors.white)),
                                  )
                              ),
                            ):
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.green
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Verified",style:TextStyle(color:Colors.white)),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Row(
                              children: const [
                                Text("Upload front Ghana Card"),
                                SizedBox(width: 10),
                                Icon(Icons.upload,color:muted)
                              ],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("We will be matching your details on your card with the one you have already provided",style: TextStyle(color:muted,fontSize: 12)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
              ),
            ),

            const SizedBox(height: 20),
            !userController.verified ? Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text("You need at least one person from Taxinet to refer you.")
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Padding(
                      //   padding:
                      //   const EdgeInsets
                      //       .only(
                      //       bottom:
                      //       10.0),
                      //   child:
                      //   TextFormField(
                      //     readOnly: userController.referral != "" ? true : false,
                      //     controller:
                      //     referralController,
                      //     cursorColor:
                      //     Colors.black,
                      //     cursorRadius:
                      //     const Radius
                      //         .elliptical(
                      //         10, 10),
                      //     cursorWidth: 10,
                      //     decoration: InputDecoration(
                      //         labelText:
                      //         "Enter referral name",
                      //         labelStyle:
                      //         const TextStyle(
                      //           color:
                      //           Colors.black,),
                      //         focusColor:
                      //         Colors.black,
                      //         fillColor:
                      //         Colors.black,
                      //         focusedBorder: OutlineInputBorder(
                      //             borderSide: const BorderSide(
                      //                 color:
                      //                 Colors.black,
                      //                 width:
                      //                 2),
                      //             borderRadius:
                      //             BorderRadius.circular(
                      //                 12)),
                      //         border: OutlineInputBorder(
                      //             borderRadius:
                      //             BorderRadius.circular(
                      //                 12))),
                      //     keyboardType:
                      //     TextInputType
                      //         .text,
                      //     validator:
                      //         (value) {
                      //       if (value!
                      //           .isEmpty) {
                      //         return "Please enter referral name";
                      //       }
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                          height: 20),
                      Column(
                        children: [
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
                              _startPosting();
                              setState(() {
                                isPosting = true;
                              });

                              // if (_formKey
                              //     .currentState!
                              //     .validate()) {
                              //   userController.updatePassengerProfile(referralController.text.trim());
                              // } else {
                              //   return;
                              // }
                            },
                            // child: const Text("Send"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    8)),
                            elevation: 8,
                            child: const Text(
                              "Send",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  fontSize: 15,
                                  color:
                                  defaultTextColor1),
                            ),
                            fillColor:
                            Colors.black,
                            splashColor:
                            defaultColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Center(
                      child: Text("Add later",style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                )
              ],
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
