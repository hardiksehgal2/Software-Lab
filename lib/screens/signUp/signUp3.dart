import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:software_lab/screens/signUp/signUp4.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  State<SignUp3> createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  String? _selectedDocumentName;
  String? _selectedDocumentPath;
  late Map<String, dynamic> formData;

  @override
  void initState() {
    super.initState();
    // Initialize formData with arguments from previous screen
    formData = Map<String, dynamic>.from(Get.arguments ?? {});
  }

  Future<void> requestPermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print('Storage permission granted');
    } else {
      print('Storage permission denied');
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _selectedDocumentName = result.files.single.name;
        _selectedDocumentPath = result.files.single.path;
        // Update formData to include only the file name
        formData['registration_proof'] = _selectedDocumentName;
      });
    }
  }

  void _continue() {
    print('Form Data: $formData');
    
    // Navigate to SignUp4 and pass the formData to the next screen
    Get.to(()=>
    SignUp4(), arguments: formData,
transition: Transition
              .rightToLeftWithFade, // Change to your preferred animation
          duration: const Duration(milliseconds: 300)
    
    );
  }

  void _goBack() {
    Get.back();
  }

  void _removeDocument() {
    setState(() {
      _selectedDocumentName = null;
      _selectedDocumentPath = null;
      formData.remove('registration_proof'); // Remove document from formData
    });
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
              child: "Signup 3 of 4"
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
                  "Attached proof of Department of Agriculture registrations i.e. Florida Fresh, USDA Approved, USDA Organic"
                      .text
                      .textStyle(GoogleFonts.beVietnamPro())
                      .start
                      .gray400
                      .make(),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Attach proof of registration"
                    .text
                    .textStyle(GoogleFonts.beVietnamPro())
                    .start
                    .black
                    .make(),
                GestureDetector(
                  onTap: _pickDocument,
                  child: Container(
                    height: 70,
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD5715B),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/camera.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            if (_selectedDocumentName != null)
              Stack(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: '$_selectedDocumentName'
                                  .text
                                  .textStyle(GoogleFonts.beVietnamPro())
                                  .underline
                                  .make()),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: _removeDocument,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: _goBack,
                ),
                GestureDetector(
                  onTap: _continue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5715B),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        _selectedDocumentName != null ? 'Submit' : 'Continue',
                        style: GoogleFonts.beVietnamPro(color: Colors.white),
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
    );
  }
}
