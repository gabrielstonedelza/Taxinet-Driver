import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxinet_driver/controllers/schedulescontroller.dart';
import '../../../constants/app_colors.dart';

import '../home/scheduledetail.dart';



class DailySchedules extends StatefulWidget {

  const DailySchedules({Key? key}) : super(key: key);

  @override
  State<DailySchedules> createState() => _DailySchedulesState();
}

class _DailySchedulesState extends State<DailySchedules> {

  var items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Daily Schedules"),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<ScheduleController>(builder:(scheduleController){
          return ListView.builder(
              itemCount: scheduleController.allDailySchedules != null ? scheduleController.allDailySchedules.length : 0,
              itemBuilder: (context,index){
                items = scheduleController.allDailySchedules[index];
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
                              Get.to(()=> ScheduleDetail(slug:scheduleController.allDailySchedules[index]['slug'],id:scheduleController.allSchedules[index]['id'].toString()));
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