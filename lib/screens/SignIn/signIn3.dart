import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:software_lab/screens/SignIn/signIn4.dart'; // Import SignIn4 screen
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:firebase_auth/firebase_auth.dart';

class SignIn3 extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const SignIn3(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<SignIn3> createState() => _SignIn3State();
}

class _SignIn3State extends State<SignIn3> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _initFocusNodes();
    _verificationId = widget.verificationId;

    // Add listeners to each controller to clear text on backspace
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].addListener(() {
        _handleTextChange(i);
      });
    }
  }

  void _initFocusNodes() {
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (_otpFocusNodes[i].hasFocus) {
          _otpControllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _otpControllers[i].text.length,
          );
        }
      });
    }
  }

  void _handleTextChange(int index) {
    if (_otpControllers[index].text.length > 1) {
      _otpControllers[index].text = _otpControllers[index].text[0];
    }

    if (_otpControllers[index].text.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
      }
    } else if (_otpControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
    }
  }

 void _verifyOTP() async {
  setState(() {
    _isAuthenticating = true;
  });

  final String otp = _otpControllers.map((c) => c.text).join();

  if (otp.length == 6) {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final tokenResult = await user.getIdToken();
        Get.to(() => SignIn4(token: tokenResult.toString()));
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      Get.snackbar("Error", "Verification failed",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } else {
    Get.snackbar("Error", "Please enter a valid OTP",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  setState(() {
    _isAuthenticating = false;
  });
}

  void _resendCode() async {
    print('Resending OTP to ${widget.phoneNumber}');
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
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
          print('OTP sent to ${widget.phoneNumber}');
          Get.snackbar("Success", "OTP sent successfully!",
              backgroundColor: Colors.green, colorText: Colors.white);

          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto-retrieval timeout');
        },
      );
    } catch (e) {
      print('Error occurred during phone verification: $e');
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
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
              const SizedBox(height: 90),
              Text(
                'Verify OTP',
                style: GoogleFonts.beVietnamPro(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  "Remember your password?".text.gray400.make(),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignIn1());
                    },
                    child: "Login".text.orange600.make(),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(7), // Rounded corners
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          _handleTextChange(index);
                        },
                        onEditingComplete: () {
                          if (index < 5) {
                            FocusScope.of(context)
                                .requestFocus(_otpFocusNodes[index + 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 30),
             GestureDetector(
  onTap: _isAuthenticating ? null : _verifyOTP,
  child: Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: const Color(0xFFD5715B),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Center(
      child: _isAuthenticating
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 50,
            )
          : "Submit"
              .text
              .textStyle(GoogleFonts.beVietnamPro())
              .lg
              .white
              .make(),
    ),
  ),
),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: _resendCode,
                  child: "Resend Code"
                      .text
                      .textStyle(GoogleFonts.beVietnamPro())
                      .underline
                      .black
                      .make(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
