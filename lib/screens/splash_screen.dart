import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:software_lab/Utils/colors.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:software_lab/screens/signUp/signUp1.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool isRegisterExpanded = false;
  bool isSignInExpanded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isRegisterExpanded = false;
        isSignInExpanded = false;
      });
    });
  }
 



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: Container(
        color: backgroundColor1,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  color: Color.fromARGB(255, 161, 205, 162),
                  
                ),
                  child: Lottie.asset(
          "assets/images/farm.json",  // Path to your Lottie asset
          fit: BoxFit.contain,
          height: 160,
          width: 160,
        

        ),
              ),
            ),
            Positioned(
              top: size.height * 0.6,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    FadeInUp(
                      from: 150,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Discover here the \n',
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: textColor1,
                            height: 1.2,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Farming Guide ',
                              style: GoogleFonts.beVietnamPro(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                            // TextSpan(
                            //   text: 'here',
                            //   style: GoogleFonts.pottaOne(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 40,
                            //     color: textColor1,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FadeInUp(
                      from: 150,
                      child: Text(
                        "Explore all the most exciting farm tricks\nbased on expert knowledge",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          color: textColor2,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: backgroundColor3.withOpacity(0.9),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: size.height * 0.08,
                                width: size.width / 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isRegisterExpanded = !isRegisterExpanded;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Get.to(() => const SignUp1(),
                                          transition: Transition.circularReveal,
                                          duration: const Duration(milliseconds: 1300))
                                        ?.then((_) {
                                          // Reset state when returning from SignIn
                                          setState(() {
                                            isRegisterExpanded = false;
                                            isSignInExpanded = false;
                                          });
                                        });
                                    });
                                  },
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 500),
                                      style: GoogleFonts.beVietnamPro(
                                        fontWeight: FontWeight.bold,
                                        color: isRegisterExpanded ? Colors.red : textColor1,
                                        fontSize: isRegisterExpanded ? 30 : 20,
                                      ),
                                      child: const Text("Register"),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: size.height * 0.08,
                                  width: size.width / 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSignInExpanded = !isSignInExpanded;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 500), () {
                                        Get.to(() => const SignIn1(),
                                            transition: Transition.circularReveal,
                                            duration: const Duration(milliseconds: 1300))
                                          ?.then((_) {
                                            // Reset state when returning from SignIn
                                            setState(() {
                                              isRegisterExpanded = false;
                                              isSignInExpanded = false;
                                            });
                                          });
                                      });
                                    },
                                    child: Center(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 500),
                                        style: GoogleFonts.beVietnamPro(
                                          fontWeight: FontWeight.bold,
                                          color: isSignInExpanded ? Colors.red : textColor1,
                                          fontSize: isSignInExpanded ? 30 : 20,
                                        ),
                                        child: const Text("Sign In"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
