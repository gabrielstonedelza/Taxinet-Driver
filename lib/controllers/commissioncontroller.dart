import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommissionController extends GetxController{
  List myCommission = [];
  bool isLoading = true;
  double totalCommissions = 0;
  List paidDate = [];
  String driver = "";

  Future<void> getAllCommissions(String token) async {
    try{
      isLoading = true;
      const url = "https://taxinetghana.xyz/get_my_commission/";
      var myLink = Uri.parse(url);
      final response =
      await http.get(myLink, headers: {"Authorization": "Token $token"});
      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        myCommission = json.decode(jsonData);

        for(var i in myCommission){
          if(!paidDate.contains(i['date_paid'])){
            paidDate.add(i['date_paid']);
            driver = i['driver'].toString();
            totalCommissions = totalCommissions + double.parse(i['amount']);
          }
        }
        update();
      } else {
        if (kDebugMode) {
          // print(response.body);
        }
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    finally {
      isLoading = false;
    }
  }
}