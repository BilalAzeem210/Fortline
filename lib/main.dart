import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fortline_customer_app/Screen/Customer_Details_Screen.dart';
import 'package:fortline_customer_app/firebase_options.dart';

import 'Screen/Splash_Screen.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fortline Customer App',

      home: SplashScreen(),
    );
  }
}



