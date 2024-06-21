import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/view/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/app-icon-removebg-preview.png",
              height: 250,
              width: 260,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 140,left: 140),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
