import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../constants/app_colors.dart';
import '../../../views/login/loginview.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
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
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: (){
              Get.defaultDialog(
                  buttonColor: primaryColor,
                  title: "Confirm Logout",
                  middleText: "Are you sure you want to logout?",
                  confirm: RawMaterialButton(
                      shape: const StadiumBorder(),
                      fillColor: primaryColor,
                      onPressed: () {
                        logoutUser();
                        Get.back();
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      )),
                  cancel: RawMaterialButton(
                      shape: const StadiumBorder(),
                      fillColor: primaryColor,
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      )));
            },
            leading: const Icon(Icons.logout),
            title: Text("Logout"),
          )
        ],
      ),
    );
  }
}
