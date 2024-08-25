// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:software_lab/screens/SignIn/signIn3.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSendingCode = false;

  Future<void> sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSendingCode = true;
      });
      final String phoneNumber = '+91${phoneController.text}';

      print('Sending OTP request for phone number: $phoneNumber');

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            print('Verification completed automatically.');
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Verification failed: ${e.message}');
            Get.snackbar("Error", "Verification failed: ${e.message}",
                backgroundColor: Colors.red, colorText: Colors.white);
          },
          codeSent: (String verificationId, int? resendToken) {
            print('OTP sent to $phoneNumber');
            Get.snackbar("Success", "OTP sent successfully!",
                backgroundColor: Colors.green, colorText: Colors.white);

            Get.to(
                () => SignIn3(
                    verificationId: verificationId, phoneNumber: phoneNumber),
                transition: Transition
                    .rightToLeftWithFade, // Change to your preferred animation
                duration: const Duration(milliseconds: 300));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('Code auto-retrieval timeout');
          },
        );
      } catch (e) {
        print('Error occurred during phone verification: $e');
        Get.snackbar("Error", "An error occurred: $e",
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  Widget formField(
      TextEditingController controller, String hintText, Widget prefixIcon,
      {bool obscureText = false, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $hintText';
          } else if (value.length != 10) {
            return 'Phone number must be 10 digits long';
          }
          return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.beVietnamPro(
            textStyle: TextStyle(color: Colors.grey.shade600),
          ),
          prefixIcon: Container(height: 10, width: 10, child: prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              "Software Lab".text.textStyle(GoogleFonts.beVietnamPro()).make(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    "Remember your password?"
                        .text
                        .textStyle(GoogleFonts.beVietnamPro())
                        .gray400
                        .make(),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignIn1(),
                            transition: Transition
                                .circularReveal, // Change to your preferred animation
                            duration: const Duration(milliseconds: 900));
                      },
                      child: "Login"
                          .text
                          .textStyle(GoogleFonts.beVietnamPro())
                          .orange600
                          .make(),
                    )
                  ],
                ),
                const SizedBox(height: 60),
                formField(
                  phoneController,
                  "Phone Number",
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset("assets/images/phone.svg"),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _isSendingCode ? null : sendCode,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5715B),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: _isSendingCode
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 50,
                            )
                          : "Send code"
                              .text
                              .textStyle(GoogleFonts.beVietnamPro())
                              .lg
                              .white
                              .make(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
