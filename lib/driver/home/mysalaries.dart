import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../constants/app_colors.dart';
import '../../controllers/salarycontroller.dart';

class MySalaries extends StatefulWidget {

  const MySalaries({Key? key}) : super(key: key);

  @override
  State<MySalaries> createState() => _MySalariesState();
}

class _MySalariesState extends State<MySalaries> {
  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Salaries"),
          backgroundColor:primaryColor,
        ),
        backgroundColor: primaryColor,
        body: GetBuilder<SalaryController>(builder:(salaryController){
          return ListView.builder(
              itemCount: salaryController.mySalary != null ? salaryController.mySalary.length : 0,
              itemBuilder: (context,index){
                items = salaryController.mySalary[index];
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

                            leading: const Icon(Icons.access_time_filled),
                            title: Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Text("₵${items['amount']}",style:const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text(items['date_paid']),
                                  ),
                                  Text(items['time_paid'].toString().split(".").first),
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
