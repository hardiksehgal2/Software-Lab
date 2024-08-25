// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:software_lab/screens/signUp/signUp2.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String? deviceToken;
  String? socialId;
  String? type;

  @override
  void initState() {
    super.initState();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
  }

  Future<void> storeUserDetails(String deviceToken, String socialId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_token', deviceToken);
    await prefs.setString('social_id', socialId);
  }
 Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = userCredential.user;

        // Pre-fill the form with Google data
        setState(() {
          fullNameController.text = user?.displayName ?? '';
          emailController.text = user?.email ?? '';
          socialId = user?.uid; // Google UID as social ID
          type = 'google'; // Login type
        });
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }


  Future<void> signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Validate the form before submission
        if (_formKey.currentState!.validate()) {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          User? user = userCredential.user;

          setState(() {
            socialId = user?.uid; // Firebase UID as social ID
            type = 'email'; // Login type for email/password
          });

          // Store device token and social ID in SharedPreferences
          await storeUserDetails(deviceToken ?? '', socialId ?? '');

          // Navigate to the next screen
          Get.to(() => SignUp2(), arguments: {
            'full_name': fullNameController.text,
            'role': 'farmer',
            'email': emailController.text,
            'phone': phoneController.text,
            'password': passwordController.text,
            'device_token': deviceToken,
            'social_id': socialId,
            'type': type,
          });
        }
      } catch (e) {
        print("Error during Email/Password Sign-Up: $e");

        // Provide detailed feedback based on the error code
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'email-already-in-use':
              Get.snackbar(
                "Sign-Up Error",
                "The email address is already in use by another account.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              break;
            case 'weak-password':
              Get.snackbar(
                "Sign-Up Error",
                "The password is too weak. Please use a stronger password.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              break;
            case 'invalid-email':
              Get.snackbar(
                "Sign-Up Error",
                "The email address is invalid.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              break;
            default:
              Get.snackbar(
                "Sign-Up Error",
                "An unknown error occurred. Please try again.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
          }
        } else {
          // For non-Firebase errors
          Get.snackbar(
            "Sign-Up Error",
            "An unknown error occurred. Please try again.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

// Function to sign in with Facebook
  Future<void> signInWithFacebook() async {
  try {
    // Trigger Facebook login
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (loginResult.status == LoginStatus.success) {
      // Extract access token
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      // Sign in with Firebase using the Facebook credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Pre-fill the form with Facebook data
      setState(() {
        fullNameController.text = user?.displayName ?? '';
        emailController.text = user?.email ?? '';
        socialId = user?.uid; // Facebook UID as social ID
        type = 'facebook'; // Login type
      });
    } else {
      throw FirebaseAuthException(
        code: 'Facebook Login Failed',
        message: 'The Facebook login was not successful.',
      );
    }
  } catch (e) {
    print("Error during Facebook Sign-In: $e");
  }
}

// Example function to call your API with Facebook user data
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: "FarmerEats".text.textStyle(GoogleFonts.beVietnamPro()).make(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: "Signup 1 of 4"
                      .text
                      .textStyle(GoogleFonts.beVietnamPro())
                      .start
                      .xl
                      .gray400
                      .make(),
                ),
                const SizedBox(height: 10),
                "Welcome !"
                    .text
                    .textStyle(GoogleFonts.beVietnamPro())
                    .bold
                    .xl3
                    .black
                    .make(),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: socialButton("assets/images/google_button.svg"),
                    ),
                    GestureDetector(
                      onTap: signInWithFacebook,
                      child: socialButton("assets/images/facebook_button.svg"),
                    ),
                    socialButton("assets/images/apple_button.svg"),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "or signup with".text.gray400.make(),
                  ],
                ),
                const SizedBox(height: 30),
                formField(
                  fullNameController,
                  "Full Name",
                  const Icon(Icons.person_3_outlined),
                  readOnly: fullNameController.text.isNotEmpty,
                ),
                const SizedBox(height: 20),
                formField(
                  emailController,
                  "Email Address",
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset("assets/images/email.svg"),
                  ),
                  readOnly: emailController.text.isNotEmpty,
                ),
                const SizedBox(height: 20),
                formField(
                  phoneController,
                  "Phone Number",
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset("assets/images/phone.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                formField(passwordController, "Password",
                    const Icon(Icons.lock_outline),
                    obscureText: true),
                const SizedBox(height: 20),
                formField(confirmPasswordController, "Re-enter Password",
                    const Icon(Icons.lock_outline),
                    obscureText: true),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Login"
                        .text
                        .lg
                        .textStyle(GoogleFonts.beVietnamPro())
                        .underline
                        .make()
                        .onTap(() {
                       Get.to(() => const SignIn1(),
                            transition: Transition
                                .circularReveal, // Change to your preferred animation
                            duration: const Duration(milliseconds: 1000));
                    }),
                    GestureDetector(
                      onTap: () {
                        // Check if the form is filled manually
                        if (fullNameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          signUpWithEmailAndPassword();
                        } else if (_formKey.currentState!.validate()) {
                          // If Google Sign-In was used
                          Get.to(() => SignUp2(),
                              arguments: {
                                'full_name': fullNameController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'password': passwordController.text,
                                'device_token': deviceToken,
                                'social_id': socialId,
                                'type': type,
                              },
                              transition: Transition
                                  .leftToRightWithFade, // Change to your preferred animation
                              duration: const Duration(milliseconds: 600));
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFFD5715B),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 50,
                                )
                              : "Continue"
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(String assetName) {
    return InkWell(
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            assetName,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
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
          }
          return null;
        },
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
}
