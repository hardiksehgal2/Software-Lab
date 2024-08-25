import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:software_lab/screens/SignIn/signIn1.dart';
import 'package:software_lab/screens/SignIn/signIn3.dart';
import 'package:software_lab/screens/SignIn/signIn4.dart';
import 'package:software_lab/screens/signUp/signUp1.dart';
import 'package:software_lab/screens/signUp/signUp2.dart';
import 'package:software_lab/screens/signUp/signUp3.dart';
import 'package:software_lab/screens/signUp/signUp4.dart';
import 'package:software_lab/screens/signUp/signUp5.dart';
import 'package:software_lab/screens/splash_screen.dart';
import 'package:software_lab/sliding.dart';
import 'package:software_lab/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBh-dwHGPjUtgJVBQfd7Y-vobK-eHoA44I",
        authDomain: "software-lab-db185.firebaseapp.com",
        projectId: "software-lab-db185",
        storageBucket: "software-lab-db185.appspot.com",
        messagingSenderId: "311239846218",
        appId: "1:311239846218:android:79041a0ad583a2a35bf9b3",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App Title',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/signUp1', page: () => const SignUp1()),
        GetPage(name: '/signUp2', page: () => SignUp2()),
        GetPage(name: '/signUp3', page: () =>  const SignUp3()),
        GetPage(name: '/signUp4', page: () =>  const SignUp4()),
        GetPage(name: '/signIn1', page: () =>  const SignIn1()),
        GetPage(name: '/splashScreen', page: () =>  const MySplashScreen()),
        GetPage(name: '/sliding1', page: () =>  const Sliding1()),
        GetPage(name: '/signUp5', page: () =>  const SignUp5()),
        GetPage(name: '/welcome', page: () =>   WelcomeScreen()),
        GetPage(name: '/signIn4', page: () =>  const SignIn4(token: '',)),
        GetPage(name: '/signIn3', page: () =>  const SignIn3(verificationId: '', phoneNumber: '',)),


      ],
    );
  }
}