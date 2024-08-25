// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:software_lab/screens/SignIn/signIn2.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp5 extends StatefulWidget {
  const SignUp5({super.key});

  @override
  State<SignUp5> createState() => _SignUp5State();
}

class _SignUp5State extends State<SignUp5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  child: Column(
                    children: [
                      Center(
                          child:
                              SvgPicture.asset('assets/images/green_tick.svg')),
                      const SizedBox(
                        height: 80,
                      ),
                      "You’re all done!"
                          .text
                          .xl3
                          .bold
                          .textStyle(GoogleFonts.beVietnamPro())
                          .make(),
                      const SizedBox(
                        height: 40,
                      ),
                      "Hang tight!  We are currently reviewing your account and will follow up with you in 2-3 business days. In the meantime, you can setup your inventory."
                          .text
                          .center
                          .gray400
                          .make(),
                    ],
                  ),
                ),
              ),

              // const Spacer(),
              SizedBox(height: 100,),

              GestureDetector(
                onTap: () {
                  Get.to(SignIn2(), transition: Transition
                                .circularReveal, // Change to your preferred animation
                            duration: const Duration(milliseconds: 1000));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5715B),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: "Submit"
                          .text
                          .textStyle(GoogleFonts.beVietnamPro())
                          .lg
                          .white
                          .make(),
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
