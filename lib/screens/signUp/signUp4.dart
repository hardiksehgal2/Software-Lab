// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:software_lab/screens/signUp/signUp5.dart';
import 'package:software_lab/screens/splash_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp4 extends StatefulWidget {
  const SignUp4({super.key});

  @override
  State<SignUp4> createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {
  bool isLoading = false;

  int selectedDay = -1;
  List<List<bool>> selectedTimes =
      List.generate(7, (_) => List.filled(5, false));
  late Map<String, dynamic> formData;

  final List<String> days = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];
  final List<String> times = [
    '8:00am - 10:00am',
    '10:00am - 1:00pm',
    '1:00pm - 4:00pm',
    '4:00pm - 7:00pm',
    '7:00pm - 10:00pm'
  ];

  @override
  void initState() {
    super.initState();
    formData = Map<String, dynamic>.from(Get.arguments ?? {});
    print('Previous screen data: ${jsonEncode(formData)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('FarmerEats', style: GoogleFonts.beVietnamPro()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: "Signup 4 of 4"
                  .text
                  .textStyle(GoogleFonts.beVietnamPro())
                  .start
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
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child:
                  "Choose the hours your farm is open for pickups. This will allow customers to order deliveries."
                      .text
                      .textStyle(GoogleFonts.beVietnamPro())
                      .start
                      .gray400
                      .make(),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      List.generate(7, (index) => _buildDayContainer(index)),
                ),
                const SizedBox(height: 20),
                if (selectedDay != -1) ..._buildTimeContainers(),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: isLoading
                      ? null
                      : _submitForm, // Prevent tapping when loading
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: 50,
                    width: 200,
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
                          : Text(
                              'Submit',
                              style:
                                  GoogleFonts.beVietnamPro(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _submitForm,
      //   child: const Icon(Icons.check),
      // ),
    );
  }

  Widget _buildDayContainer(int index) {
    Color color;
    if (index == selectedDay) {
      color = Colors.orange;
    } else if (selectedTimes[index].contains(true)) {
      color = Colors.grey.shade300;
    } else {
      color = Colors.white;
    }

    return GestureDetector(
      onTap: () => setState(() => selectedDay = index),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(days[index])),
      ),
    );
  }

  List<Widget> _buildTimeContainers() {
    return [
      Row(
        children: [
          Expanded(child: _buildTimeContainer(0)),
          const SizedBox(width: 10),
          Expanded(child: _buildTimeContainer(1)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _buildTimeContainer(2)),
          const SizedBox(width: 10),
          Expanded(child: _buildTimeContainer(3)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _buildTimeContainer(4)),
          const Expanded(child: SizedBox()), // Empty container for alignment
        ],
      ),
    ];
  }

  Widget _buildTimeContainer(int index) {
    String time = times[index];
    bool isSelected = selectedTimes[selectedDay][index];

    return GestureDetector(
      onTap: () =>
          setState(() => selectedTimes[selectedDay][index] = !isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(time,
            style: GoogleFonts.beVietnamPro(), textAlign: TextAlign.center),
      ),
    );
  }

  Map<String, dynamic> getBusinessHours() {
    Map<String, dynamic> businessHours = {};
    final List<String> dayKeys = [
      'mon',
      'tue',
      'wed',
      'thu',
      'fri',
      'sat',
      'sun'
    ];

    for (int i = 0; i < days.length; i++) {
      List<String> selectedHours = [];
      for (int j = 0; j < times.length; j++) {
        if (selectedTimes[i][j]) {
          selectedHours.add(times[j]);
        }
      }
      if (selectedHours.isNotEmpty) {
        businessHours[dayKeys[i]] = selectedHours;
      }
    }

    return {'business_hours': businessHours};
  }

 void _submitForm() async {
  setState(() {
    isLoading = true; // Set loading to true when starting form submission
  });

  Map<String, dynamic> businessHours = getBusinessHours();
  formData.addAll(businessHours);
  print('Form Data: ${jsonEncode(formData)}');

  final url = Uri.parse('https://sowlab.com/assignment/user/register');
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Parse the response body
    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['success'] == true) {
      // If the registration is successful, navigate to SignIn5
      Get.to(() => const SignUp5());
    } else {
      // Handle the failure (e.g., email already exists)
      print('Registration failed: ${responseBody['message']}');
      Get.snackbar("Registration Failed", responseBody['message'],
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print('Error during registration: $e');
    Get.snackbar("Registration Error", "Something went wrong. Please try again.",
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    setState(() {
      isLoading = false; // Set loading to false after completion
    });
  }
}

}
