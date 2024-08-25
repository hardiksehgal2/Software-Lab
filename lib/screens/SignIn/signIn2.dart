import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:software_lab/screens/splash_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../SignIn/signIn1.dart';
// import '../MySplashScreen.dart';  // Make sure to import the MySplashScreen class

class SignIn2 extends StatefulWidget {
  const SignIn2({super.key});

  @override
  State<SignIn2> createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to MySplashScreen instead of SignIn1
      Get.offAll(() => const MySplashScreen(), transition: Transition
                                .circularReveal, // Change to your preferred animation
                            duration: const Duration(milliseconds: 1000));
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar(
        "Sign Out Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,  // Remove shadow
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: "FarmerEats".text.textStyle(GoogleFonts.beVietnamPro()).make(),
        ),
        leading: SizedBox(),  // Hide the back arrow icon
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              "Welcome to FarmerEats!"
                  .text
                  .textStyle(GoogleFonts.beVietnamPro())
                  .bold
                  .xl3
                  .black
                  .make(),
              const SizedBox(height: 50),
              // Use Container for the design
              Center(
                child: Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5715B),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,  // Override default color
                      elevation: 0,  // Remove default shadow
                      padding: EdgeInsets.zero,  // Remove padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: "Sign out"
                          .text
                          .textStyle(GoogleFonts.beVietnamPro())
                          .lg
                          .white
                          .make(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
