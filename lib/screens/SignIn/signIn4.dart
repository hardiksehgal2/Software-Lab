import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:velocity_x/velocity_x.dart';

class SignIn4 extends StatefulWidget {
  final String token;
  const SignIn4({super.key, required this.token});

  @override
  State<SignIn4> createState() => _SignIn4State();
}

class _SignIn4State extends State<SignIn4> {
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
              const SizedBox(height: 90),
              "Reset Password"
                  .text
                  .xl3
                  .textStyle(GoogleFonts.beVietnamPro())
                  .bold
                  .make(),
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
                      Get.to(() => SignIn1());
                    },
                    child: "Login"
                        .text
                        .orange600
                        .textStyle(GoogleFonts.beVietnamPro())
                        .make(),
                  ),
                  const SizedBox(height: 60),
                  formField("Password", const Icon(Icons.lock_outline),
                      obscureText: true),
                  const SizedBox(height: 30),
                  formField("Re-enter Password", const Icon(Icons.lock_outline),
                      obscureText: true),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formField(String hintText, Widget prefixIcon,
      {bool obscureText = false, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        // controller: controller,
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
