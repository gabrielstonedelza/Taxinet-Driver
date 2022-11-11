import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:taxinet_driver/driver/home/pages/completeset.dart';
import 'package:taxinet_driver/driver/home/verifiedprofile.dart';

import '../../../constants/app_colors.dart';

import "package:get/get.dart";

import '../../g_controllers/user/user_controller.dart';
import '../../views/login/newlogin.dart';
import 'mysalaries.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final storage = GetStorage();
  UserController userController = Get.find();
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

  logoutUser() async {
    // storage.remove("username");
    // storage.remove("userToken");
    // storage.remove("userType");
    // storage.remove("verified");
    // storage.remove("userid");
    Get.offAll(() => const NewLogin());
    // const logoutUrl = "https://taxinetghana.xyz/auth/token/logout";
    // final myLink = Uri.parse(logoutUrl);
    // http.Response response = await http.post(myLink, headers: {
    //   'Accept': 'application/json',
    //   "Authorization": "Token $uToken"
    // });
    //
    // if (response.statusCode == 200) {
    //
    //   Get.snackbar("Success", "You were logged out",
    //       colorText: Colors.white,
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: snackColor);
    //   storage.remove("username");
    //   storage.remove("userToken");
    //   Get.offAll(() => const NewLogin());
    // }
  }
  var uToken = "";
  var username = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor:primaryColor,
          body: SlideInUp(
            animate: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> const VerifiedProfile());
                    },
                    child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              userController.profileImageUpload != null
                                  ? GetBuilder<UserController>(
                                builder: (controller) {
                                  return Container(
                                    width:50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: FileImage(
                                                userController.profileImageUpload!),
                                            fit: BoxFit.cover)),
                                  );
                                },
                              )
                                  : GetBuilder<UserController>(
                                builder: (controller) {
                                  return Container(
                                    width:50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                userController.profileImage),
                                            fit: BoxFit.cover)),
                                  );
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GetBuilder<UserController>(
                                      builder: (controller) {
                                        return Text(
                                          controller.fullName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        );
                                      }),
                                  const SizedBox(height: 10),
                                  GetBuilder<UserController>(
                                    builder: (controller) {
                                      return Text(controller.email,style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12),);
                                    },
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,color: Colors.grey)
                            ],
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CompleteSetUp());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     const Icon(Icons.person_outlined,color: muted),
                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: const [
                          //         Text("Verify Identity",style: TextStyle(fontWeight: FontWeight.bold)),
                          //         SizedBox(height: 10),
                          //         Text("Complete your account verification",style:TextStyle(color: muted,fontSize: 12)),
                          //       ],
                          //     ),
                          //     const Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 15,)
                          //   ],
                          // ),
                          const SizedBox(height: 10),
                          // const Divider(),
                          const SizedBox(height: 10),
                       isPosting ? const Center(
                         child: CircularProgressIndicator.adaptive(
                           strokeWidth: 5,
                           backgroundColor: primaryColor,
                         )
                       ) : RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                isPosting = true;
                              });
                              _startPosting();
                              logoutUser();

                            },
                            // child: const Text("Send"),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    8)),
                            elevation: 8,
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  fontSize: 15,
                                  color:
                                  defaultTextColor1),
                            ),
                            fillColor:
                            Colors.red,
                            splashColor:
                            defaultColor,
                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        floatingActionButton: FloatingActionButton(

          onPressed: () {
            Get.to(() => const MySalaries());
          },
          child: Image.asset("assets/images/salary.png",width:40,height:40),
        ),
      ),
    );
  }
}
