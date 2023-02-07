import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();
    super.dispose();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(seconds: 3))..repeat();
    Timer(const Duration(
        seconds: 3),
            (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),),);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          decoration: const BoxDecoration(
        gradient:  LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [
        0.1,
        0.6,
        0.9,
        ],
        colors: [
          Color(0xffce0505),
          Color(0xfffa0202),
          Color(0xffce0505),

        ],
          ),
          ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Center(child: Text('FORTLINE',style: TextStyle(fontSize: 60,
                color: Color(0xffffffff),
            fontFamily: "SpaceGrotesk",
            fontWeight: FontWeight.w500),),
            ),
            const SizedBox(height: 30,),

            Center(
              child: SpinKitFadingCircle(
                color: const Color(0xffffffff),
                size: 40.0,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
