import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import "package:get/get.dart";
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/app_colors.dart';
import '../bottomnavigation.dart';

class DriverBoarding extends StatefulWidget {
  const DriverBoarding({Key? key}) : super(key: key);

  @override
  State<DriverBoarding> createState() => _DriverBoardingState();
}

class _DriverBoardingState extends State<DriverBoarding> {
  final controller = PageController();
  bool isLastPage = false;
  final storage = GetStorage();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom:80),
          child: PageView(
            controller: controller,
            onPageChanged: (index){
              setState(() {
                isLastPage = index == 9;
              });
            },
            children: [
              buildPage(primaryColor,"Rules And Regulations","Please make sure to read all rules and regulations carefully."),
              buildPage(primaryColor,"Daily Payment","Driver will pay upfront sales of GH₵70 by using the app wallet after filling the inventory before he can start the vehicle."),
              buildPage(primaryColor,"Report","Driver is required to report once a week for vehicle inspection."),
              buildPage(primaryColor,"Excuses & Permissions","The driver is to give a three (3) days prior notice for any excuse of work"),
              buildPage(primaryColor,"Health Status","In case of any sickness,driver will have to park the vehicle until full recovery."),
              buildPage(primaryColor,"Vehicle Damage","Driver will bear any cost of careless driving that leads to damage of the vehicle."),
              buildPage(primaryColor,"Traveling beyond boundaries","Driver cannot go outside Kumasi without approval from the management"),
              buildPage(primaryColor,"Third Party driver","Drive have no right to give the vehicle to third party to drive without approval from the management."),
              buildPage(primaryColor,"Vehicle lock & unlock alerts","Driver will receive a daily alert (Sms) to park the vehicle before 12am which is when the vehicle and app gets locked.Drivers app will be unlocked automatically when it's 4am in the morning,vehicle too would be unlocked when driver makes payment for the day."),
              buildPage(primaryColor,"Cargo Forbidden","Driver has no right to use the vehicle for loading goods."),
              buildPage(primaryColor,"Commissions","Driver will receive  a commission of 10% on his daily sale and receive a bonus every month if he works all the days of the month."),
            ],
          ),
        ),
        bottomSheet: isLastPage ? Container(
          padding: const EdgeInsets.symmetric(horizontal:10),
          height: 80,
          width:MediaQuery.of(context).size.width,
          color:Colors.black,
          child: TextButton(
              onPressed: () async{
                storage.write("viewedIntro","ViewedInto");
                Get.offAll(()=> const MyBottomNavigationBar());
              },
              child: const Text("Get Started",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize:20))
          ),
        ) :Container(
            padding: const EdgeInsets.symmetric(horizontal:10),
            height: 80,
            color:Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    child: const Text("Skip",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                    onPressed: (){
                      Get.offAll(()=> const MyBottomNavigationBar());
                    }
                ),
                Center(child:SmoothPageIndicator(
                  controller: controller,
                  count: 7,
                  onDotClicked: (index){
                    controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  },
                )),
                TextButton(
                    child: const Text("Next",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white)),
                    onPressed: (){
                      controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    }
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget buildPage(Color color,String title,String subtitle){
    return Container(
        color: color,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize:30)),
            const SizedBox(height:20),
            Container(
                padding: const EdgeInsets.all(20),
                child: Text(subtitle,style: const TextStyle(fontWeight: FontWeight.bold,fontSize:15))
            )
          ],
        )
    );
  }

}
