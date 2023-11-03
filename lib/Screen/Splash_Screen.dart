import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fortline_app/Screen/AdsAndMenuTwo.dart';

import 'Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(
        seconds: 6),
            (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView(),),);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/splash.png"),fit: BoxFit.cover)
          ),
      ),
    ),
    );
  }
}
