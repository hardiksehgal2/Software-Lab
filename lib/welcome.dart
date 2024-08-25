import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:software_lab/screens/SignIn/signIn2.dart';
import 'package:software_lab/screens/splash_screen.dart';
import 'package:software_lab/sliding.dart';
  // Import your Sliding1 screen

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLoginStatus();

    return Scaffold(
      body: Center(
        child:Lottie.asset(
          "assets/images/farm2.json",  
          fit: BoxFit.contain,
          height: 250,
          width: 250,
        

        ),  // Show a loading indicator while checking login status
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    await Future.delayed(const Duration(seconds: 3));


    if (isLoggedIn) {
      // Navigate to SignIn2 if user is logged in
      Get.offAll(() => const SignIn2(), transition: Transition.circularReveal, duration: const Duration(milliseconds: 1000));
    } else {
      // Navigate to Sliding1 if user is not logged in
      Get.offAll(() => const Sliding1(), transition: Transition.circularReveal, duration: const Duration(milliseconds: 1000));
    }
  }
}
