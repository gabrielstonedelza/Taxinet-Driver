import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/app_colors.dart';
import '../../../views/login/loginview.dart';
import '../fab_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final storage = GetStorage();
  late String uToken = "";
  var username = "";
  var items;
  late List userProfile = [];
  late List userData = [];
  var userId = "";
  var profilePic = "";
  var taxinetNumber = "";
  var carName = "";
  var carModel = "";
  var licensePlate = "";
  bool verified = false;
  bool isLoading = true;


  Future<void> getDriverProfile() async {
    const profileUrl = "https://taxinetghana.xyz/driver-profile/";
    final myProfile = Uri.parse(profileUrl);
    final response =
    await http.get(myProfile, headers: {"Authorization": "Token $uToken"});

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      userProfile = json.decode(jsonData);
      for (var i in userProfile) {
        setState(() {
          profilePic = i['driver_profile_pic'];
          carName = i['car_name'];
          carModel = i['car_model'];
          verified = i['verified'];
          licensePlate = i['license_plate'];
          taxinetNumber = i['taxinet_number'];
        });
      }
    }
    setState(() {
      isLoading = false;
      userProfile = userProfile;
    });
  }

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
    getDriverProfile();
  }

  logoutUser() async {
    storage.remove("username");
    Get.offAll(() => const LoginView());
    const logoutUrl = "https://taxinetghana.xyz/auth/token/logout";
    final myLink = Uri.parse(logoutUrl);
    http.Response response = await http.post(myLink, headers: {
      'Accept': 'application/json',
      "Authorization": "Token $uToken"
    });

    if (response.statusCode == 200) {
      Get.snackbar("Success", "You were logged out",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      storage.remove("username");
      storage.remove("userToken");
      storage.remove("user_type");
      Get.offAll(() => const LoginView());
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text("Your Profile",style: TextStyle(color: primaryColor),),
        //   backgroundColor: defaultTextColor2,
        // ),
        body: isLoading ? const Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            backgroundColor: primaryColor,
          ),
        ) :Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                color: defaultTextColor2,
                elevation: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(

                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profilePic),
                          radius: 50,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${username.toString().capitalize}",style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            const Text(" : ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            Text(taxinetNumber,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Car Type ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            const Text(" - ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            Text(carName,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Car Model ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            const Text(" - ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                            Text(carModel,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/check.png",width: 40,height: 40,),
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text("You are verified",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            // ListTile(
            //   onTap: (){
            //     Get.defaultDialog(
            //         buttonColor: primaryColor,
            //         title: "Confirm Logout",
            //         middleText: "Are you sure you want to logout?",
            //         confirm: RawMaterialButton(
            //             shape: const StadiumBorder(),
            //             fillColor: primaryColor,
            //             onPressed: () {
            //               logoutUser();
            //               Get.back();
            //             },
            //             child: const Text(
            //               "Yes",
            //               style: TextStyle(color: Colors.white),
            //             )),
            //         cancel: RawMaterialButton(
            //             shape: const StadiumBorder(),
            //             fillColor: primaryColor,
            //             onPressed: () {
            //               Get.back();
            //             },
            //             child: const Text(
            //               "Cancel",
            //               style: TextStyle(color: Colors.white),
            //             )));
            //   },
            //   leading: const Icon(Icons.logout),
            //   title: const Text("Logout"),
            // )
          ],
        ),
        floatingActionButton: myFabMenu(),
      ),
    );
  }
}
