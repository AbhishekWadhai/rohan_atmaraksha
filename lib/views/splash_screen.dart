import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay (e.g., 2 seconds) and navigate to the main screen
    Timer(Duration(seconds: 2), () {
        // Update to your home route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Image.asset('assets/splash_icon.png', width: 100, height: 100), // Centered logo
      ),
    );
  }
}
