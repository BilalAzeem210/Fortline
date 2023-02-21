import 'dart:async';
import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'Screen/ForGroundLocalNotification.dart';
import 'Screen/get_fcm.dart';
import 'Screen/Splash_Screen.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message codewaa: ${message.messageId}");
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 /*AwesomeNotifications().initialize(null, [
    NotificationChannel(channelKey: "basic", channelName: "Basic notification", channelDescription: "Notification for test")
  ]);
  Timer(const Duration(seconds: 3), () async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async{
      if(!isAllowed){
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
      else {
        var response = await http.get(
            Uri.http("142.132.194.26:1251", "/ords/fortline/reg/notification"));
        print("notification");
        var responseData = jsonDecode(response.body.toString())["items"];
        print(responseData.toString());
        AwesomeNotifications().createNotification(
            content: NotificationContent(id: 10,
                channelKey: "basic",
                title: responseData[responseData.length - 1]["rcvddate"],
                body: responseData[responseData.length - 1]["notification"],
            ));
      }
    });

  });*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getFcmToken().then((token){
      print("fcm token: $token");
    });
    LocalNotification.initialize();
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fortline Customer App',

      home: SplashScreen(),
    );
  }
}



