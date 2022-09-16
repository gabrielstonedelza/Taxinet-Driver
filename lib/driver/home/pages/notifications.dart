import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../bottomnavigation.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/notificationController.dart';
import '../../../g_controllers/user/user_controller.dart';
import '../../../widgets/shimmers/shimmerwidget.dart';
import '../scheduledetail.dart';



class Notifications extends StatefulWidget {

  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final uController = Get.put(UserController());

  NotificationController notificationController = Get.find();
  final storage = GetStorage();

  late String username = "";

  late String uToken = "";

  var items;

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
    // for(var i in notificationController.allNotifications){
    //   notificationController.updateReadNotification(i['id']);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:primaryColor,
      body: notificationController.allNotifications != null ? ListView.builder(
          itemCount: notificationController.allNotifications != null ? notificationController.allNotifications.length :0,
          itemBuilder: (context,index){
            items = notificationController.allNotifications[index];
            return notificationController.allNotifications == null ? const ShimmerWidget.rectangular(height: 20) :Column(
              children: [
                const SizedBox(height: 10,),
                SlideInUp(
                  animate: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18,right: 18),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:items['read'] == "Read" ? ListTile(
                        leading: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.notifications)
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Text(items['notification_title']),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(items['notification_message']),
                        ),
                      ) :ListTile(
                        onTap: (){
                          notificationController.updateReadNotification(notificationController.allNotifications[index]['id']);
                          if(items['title'] == "Wallet Loaded"){
                            Get.offAll(() => const MyBottomNavigationBar());
                          }
                          if(items['title'] == "New ride assigned"){
                            Get.to(()=> ScheduleDetail(slug:notificationController.allNotifications[index]['schedule_ride_slug'],title:notificationController.allNotifications[index]['schedule_ride_title'],id:notificationController.allNotifications[index]['notification_id']));
                          }
                          if(items['title'] == "Wallet Updated"){
                            Get.offAll(() => const MyBottomNavigationBar());
                          }
                        },
                        leading: const CircleAvatar(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.notifications)
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                          child: Text(items['notification_title'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(items['notification_message']),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );

          }
      ):const Center(
        child: Text("You have no notifications"),
      ),
    );
  }
}