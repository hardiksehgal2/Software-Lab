// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:software_lab/screens/signUp/signUp3.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp2 extends StatefulWidget {
  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final businessNameController = TextEditingController();
  final informalNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final stateController2 = ''.obs;
  bool isLoading = false;

  final states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  final _formKey = GlobalKey<FormState>();

  void goToNextScreen() {
    if (_formKey.currentState!.validate()) {
      // Retrieve any existing data passed from the previous screen
      Map<String, dynamic> formData = {
        'business_name': businessNameController.text,
        'informal_name': informalNameController.text,
        'address': streetAddressController.text,
        'city': cityController.text,
        'state': stateController2.value,
        'zip_code': zipCodeController.text,
        if (Get.arguments != null) ...Get.arguments as Map<String, dynamic>,
      };

      printFormData(formData);

      Get.to(() => const SignUp3(),
          arguments: formData,
          transition: Transition
              .rightToLeftWithFade, // Change to your preferred animation
          duration: const Duration(milliseconds: 300));
    }
  }

  void printFormData(Map<String, dynamic> formData) {
    print('Form Data Collected on Current Screen:');
    print('Business Name: ${formData['business_name']}');
    print('Informal Name: ${formData['informal_name']}');
    print('Street Address: ${formData['address']}');
    print('City: ${formData['city']}');
    print('State: ${formData['state']}');
    print('Zip Code: ${formData['zip_code']}');

    // Check if there is data from the previous screen
    if (Get.arguments != null) {
      print('Data from Previous Screen:');
      Get.arguments.forEach((key, value) {
        print('$key: $value');
      });
    }
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 13.0),
                    child: "Signup 2 of 4"
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
                  buildTextField(
                    controller: businessNameController,
                    hint: 'Business Name',
                    svgPath: 'assets/images/tag.svg',
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your Business Name'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  buildTextField(
                    controller: informalNameController,
                    hint: 'Informal Name',
                    svgPath: 'assets/images/smile.svg',
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your Informal Name'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  buildTextField(
                    controller: streetAddressController,
                    hint: 'Street Address',
                    svgPath: 'assets/images/home.svg',
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your Street Address'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  buildTextField(
                    controller: cityController,
                    hint: 'City',
                    svgPath: 'assets/images/location.svg',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your City' : null,
                  ),
                  const SizedBox(height: 10),

                  // Row for dropdowns
                  Row(
                    children: [
                      Expanded(
                        flex: 2, // Decrease width of state dropdown
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Obx(() => buildDropdown(
                                hint: 'State',
                                value: stateController2.value,
                                items: states,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    stateController2.value = newValue;
                                  }
                                },
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 3, // Increase width of zipcode field
                        child: buildTextField(
                          controller: zipCodeController,
                          hint: 'Zipcode',
                          svgPath: 'assets/images/zipcode_icon.svg',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your Zipcode'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 220),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                GestureDetector(
                  onTap: goToNextScreen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5715B),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.beVietnamPro(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.0),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required String svgPath,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SvgPicture.asset(svgPath, width: 24, height: 24),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              style: GoogleFonts.beVietnamPro(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.beVietnamPro(),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.beVietnamPro(),
          ),
          value: value?.isEmpty ?? true ? null : value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.beVietnamPro(),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
