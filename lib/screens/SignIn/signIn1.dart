// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_lab/screens/signUp/signUp1.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'signIn2.dart';
import 'forgetPassword.dart';
// import 'signUp1.dart';

class SignIn1 extends StatefulWidget {
  const SignIn1({super.key});

  @override
  State<SignIn1> createState() => _SignIn1State();
}

class _SignIn1State extends State<SignIn1> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String bearerToken = '';
  bool isLoading = false; // Added to manage loading state

 Future<void> loginUser() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceToken = prefs.getString('device_token') ?? '';
      final socialId = prefs.getString('social_id') ?? '';

      final response = await http.post(
        Uri.parse('https://sowlab.com/assignment/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'role': 'farmer',
          'device_token': deviceToken,
          'type': 'email',
          'social_id': socialId,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          bearerToken = response.headers['authorization'] ?? '';

          // Store the login status in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Navigate to SignIn2 screen
          Get.offAll(() => const SignIn2(), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 300));
        } else {
          print('Login failed: ${responseData['message']}');
          Get.snackbar(
            "Login Failed",
            responseData['message'] ?? "Invalid email or password.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
        Get.snackbar(
          "Login Error",
          "Unexpected error occurred. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during login: $e');
      Get.snackbar(
        "Login Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}



Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Get.snackbar("Google Sign-In", "Sign-In was canceled by user.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final deviceToken = prefs.getString('device_token') ?? '';

      final response = await http.post(
        Uri.parse('https://sowlab.com/assignment/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': user.email,
          'role': 'farmer',
          'device_token': deviceToken,
          'type': 'google',
          'social_id': user.uid,
        }),
      );

      if (response.statusCode == 200) {
        bearerToken = response.headers['authorization'] ?? '';

        // Store the login status in SharedPreferences
        await prefs.setBool('isLoggedIn', true);

        // Navigate to SignIn2 screen
        Get.offAll(() => const SignIn2(), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 300));
      } else {
        print('Google Login failed: ${response.body}');
        Get.snackbar("Google Login Failed", "User does not exist.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  } catch (e) {
    print('Error during Google Sign-In: $e');
    Get.snackbar("Google Sign-In Error", "Something went wrong. Please try again.",
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          final prefs = await SharedPreferences.getInstance();
          final deviceToken = prefs.getString('device_token') ?? '';

          final response = await http.post(
            Uri.parse('https://sowlab.com/assignment/user/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': user.email,
              'role': 'farmer',
              'device_token': deviceToken,
              'type': 'facebook',
              'social_id': user.uid,
            }),
          );

          if (response.statusCode == 200) {
            bearerToken = response.headers['authorization'] ?? '';

            // Store the login status in SharedPreferences
            await prefs.setBool('isLoggedIn', true);

            // Navigate to SignIn2 screen
            Get.offAll(() => const SignIn2(), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 300));
          } else {
            print('Facebook Login failed: ${response.body}');
            Get.snackbar("Facebook Login Failed", "User does not exist.",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } else {
        print('Facebook Login failed: ${loginResult.message}');
        Get.snackbar("Facebook Login Failed", "Login failed.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error during Facebook Sign-In: $e');
      Get.snackbar("Facebook Sign-In Error", "Something went wrong. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget socialButton(String assetName, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
      {bool obscureText = false, bool readOnly = false, bool showForgetButton = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          TextFormField(
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
          if (showForgetButton)
            Positioned(
              right: 0,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const ForgetPassword(),
                  transition: Transition.rightToLeftWithFade, // Change to your preferred animation
    duration: const Duration(milliseconds: 300)
                  );
                },
                child: "Forget?".text.orange600.make(),
              ),
            ),
        ],
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
          child: "FarmerEats".text.textStyle(GoogleFonts.beVietnamPro()).make(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              "Welcome back!"
                  .text
                  .textStyle(GoogleFonts.beVietnamPro())
                  .bold
                  .xl3
                  .black
                  .make(),
              const SizedBox(height: 30),
              Row(
                children: [
                  "New here?".text.gray400.make(),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const SignUp1(),transition: Transition.upToDown, // Change to your preferred animation
    duration: Duration(milliseconds: 400));
                      },
                      child: "Create account".text.orange600.make())
                ],
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    formField(
                      emailController,
                      "Email Address",
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset("assets/images/email.svg"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    formField(
                      passwordController,
                      "Password",
                      const Icon(Icons.lock_outline),
                      obscureText: true,
                      showForgetButton: true,
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: GestureDetector(
                        onTap: loginUser,
                        child: Container(
                          height: 50,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5715B),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: isLoading
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.white,
                                    size: 50,
                                  )
                                : "Login"
                                    .text
                                    .textStyle(GoogleFonts.beVietnamPro())
                                    .lg
                                    .white
                                    .make(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(child: "or login with".text.gray400.make()),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        socialButton("assets/images/google_button.svg", signInWithGoogle),
                        socialButton("assets/images/apple_button.svg", () {}),
                        socialButton("assets/images/facebook_button.svg", signInWithFacebook),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
