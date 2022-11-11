import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class WalletController extends GetxController{
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  String wallet = "00";
  List walletDetails = [];
  String walletId = "";
  String userUpdatingWallet = "";
  late Timer _timer;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    // getUserWallet();
    // _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   getUserWallet();
    //   update();
    // });
  }
  Future<void> getUserWallet(String token) async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_user_wallet/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        walletDetails = jsonData;
        for (var i in walletDetails) {
          wallet = i['amount'];
          walletId = i['id'].toString();
          userUpdatingWallet = i['user'].toString();
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

}