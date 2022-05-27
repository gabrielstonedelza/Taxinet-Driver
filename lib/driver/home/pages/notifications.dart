import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/states/app_state.dart';

import '../../../constants/app_colors.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late String username = "";
  final storage = GetStorage();
  late String uToken = "";
  var items;
  late Timer _timer;
  late List allNotifications = [];
  late List allNots = [];
  bool isLoading = true;

  Future<void> getAllNotifications(String token) async {
    const url = "https://taxinetghana.xyz/notifications";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Authorization": "Token $uToken"
    });
    if(response.statusCode == 200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      allNotifications = json.decode(jsonData);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    if(storage.read("username") != null){
      setState(() {
        username = storage.read("username");
      });
    }
    if(storage.read("userToken") != null){
      setState(() {
        uToken = storage.read("userToken");
      });
    }
    getAllNotifications(uToken);
    _timer = Timer.periodic(const Duration(seconds: 12), (timer) {
      getAllNotifications(uToken);
    });

  }

  @override
  Widget build(BuildContext context) {
    final appState  = Provider.of<AppState>(context);
    return Scaffold(
      body: isLoading ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: primaryColor,
        ),
      ) : ListView.builder(
        itemCount: allNotifications != null ? allNotifications.length :0,
          itemBuilder: (context,index){
          items = allNotifications[index];
            return Column(
              children: [
                const SizedBox(height: 10,),
                ListTile(
                  onTap: (){},
                  leading: const CircleAvatar(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.notifications)
                  ),
                  title: Text(items['notification_title']),
                )
              ],
            );
          }
      ),
    );
  }
}
