import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/rxdart.dart';

class LocalNotificationManager{
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject => BehaviorSubject<ReceiveNotification>();

  LocalNotificationManager.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true
    );
  }

  initializePlatform(){
    var initSettingAndroid = const AndroidInitializationSettings("taxinet_cab");
    var initSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id,title,body,payload)async{
          ReceiveNotification notification = ReceiveNotification(id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);

        }
    );
    initSetting = InitializationSettings(android: initSettingAndroid,iOS: initSettingIOS);
  }

  setOnRideRequestNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnRideRequestNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }

  Future<void> showRideRequests(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn1")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

  setOnBidNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnBidNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }

  Future<void> showBidNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn1")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

//  send drivers car lock  notifications
  setOnCarLockNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnCarLockNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }

  Future<void> showCarLockNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn1")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }

  //  send drivers car unlock  notifications
  setOnCarUnLockNotificationReceive(Function onNotificationReceive){
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }
  setOnCarUnLockNotificationClick(Function onNotificationClick)async{
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: (String? payload)async{
      onNotificationClick(payload);
    });
  }

  Future<void> showCarUnLockNotification(String? title,String? body) async{
    var androidChannel = const AndroidNotificationDetails(
        "CHANNEL_ID",
        "CHANNEL_NAME",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("horn1")
    );
    var iosChannel = const IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0,title,body,platformChannel,payload: "New Payload");
  }
}

LocalNotificationManager localNotificationManager = LocalNotificationManager.init();

class ReceiveNotification{
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  ReceiveNotification({required this.id,required this.title,required this.body,required this.payload});
}