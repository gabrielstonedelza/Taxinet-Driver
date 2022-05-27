import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/constants/app_colors.dart';
import 'package:taxinet_driver/driver/home/pages/ride_detail.dart';

import '../../../states/app_state.dart';

class Rides extends StatefulWidget {
  const Rides({Key? key}) : super(key: key);

  @override
  State<Rides> createState() => _RidesState();
}

class _RidesState extends State<Rides> {
  var uToken = "";
  final storage = GetStorage();
  var username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final appState = Provider.of<AppState>(context,listen: false);
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    appState.getDriversRidesCompleted(uToken);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Your rides"),
        centerTitle: true,
      ),
      body: appState.loading ? const Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          color: primaryColor,
        ),
      ) :ListView.builder(
        itemCount: appState.driversRides != null ? appState.driversRides.length : 0,
          itemBuilder: (context,index){
            return Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return RideDetail(id:appState.driversRides[index]['id']);
                  }));
                },
                leading:appState.driversRides[index]['get_passenger_profile_pic'] != null ? CircleAvatar(
                  backgroundImage: NetworkImage(appState.driversRides[index]['get_passenger_profile_pic']),
                ): const Icon(Icons.person),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(appState.driversRides[index]['passengers_username'].toString().toUpperCase(),style: const TextStyle(fontSize: 12),),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(appState.driversRides[index]['pick_up'],style: const TextStyle(fontSize: 12),),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.arrow_forward_rounded,size: 12,),
                          ),
                          Text(appState.driversRides[index]['drop_off'],style: const TextStyle(fontSize: 12),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Text(appState.driversRides[index]['date_requested'].toString().split("T").first,style: const TextStyle(fontSize: 12),),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0,right: 10),
                              child: Text("|"),
                            ),
                            Text(appState.driversRides[index]['date_requested'].toString().split("T").last.split(".").first,style: const TextStyle(fontSize: 12),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
