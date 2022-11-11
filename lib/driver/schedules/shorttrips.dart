import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxinet_driver/controllers/schedulescontroller.dart';
import '../../../constants/app_colors.dart';

import '../home/scheduledetail.dart';



class ShortTrips extends StatefulWidget {

  const ShortTrips({Key? key}) : super(key: key);

  @override
  State<ShortTrips> createState() => _ShortTripsState();
}

class _ShortTripsState extends State<ShortTrips> {

  var items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Short Trips"),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<ScheduleController>(builder:(scheduleController){
          return ListView.builder(
              itemCount: scheduleController.allShortTripSchedules != null ? scheduleController.allShortTripSchedules.length : 0,
              itemBuilder: (context,index){
                items = scheduleController.allShortTripSchedules[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,),
                  child: SlideInUp(
                    animate: true,
                    child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                            onTap: (){
                              Get.to(()=> ScheduleDetail(slug:scheduleController.allShortTripSchedules[index]['slug'],id:scheduleController.allSchedules[index]['id'].toString()));
                              // Navigator.pop(context);
                            },
                            leading: const Icon(Icons.access_time_filled),
                            title: Text(items['get_passenger_name'],style:const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${items['pickup_location']} ➸ ${items['drop_off_location']}"),
                                  Text(items['date_scheduled']),
                                ],
                              ),
                            )
                        )
                    ),
                  ),
                );
              }
          );
        })
    );
  }
}