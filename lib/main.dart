import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // นำเข้า firebase_core
// import 'package:weektwo/screen/Homelogin.dart';
import 'package:weektwo/screen/home.dart';
import 'package:weektwo/screen/login.dart';
// import 'package:weektwo/screen/Homelogin.dart';
// import 'package:weektwo/screen/login.dart';
import 'firebase_options.dart'; // นำเข้า firebase_options.dart
import 'package:weektwo/constant/constant.dart';
// import 'package:weektwo/screen/Homelogin.dart';
// import 'package:weektwo/screen/async.dart';
import 'package:weektwo/screen/create.dart';
import 'package:weektwo/screen/dashboard.dart';
import 'package:weektwo/screen/dogapi.dart';
// import 'package:weektwo/screen/home.dart';
import 'package:weektwo/screen/profile.dart';
import 'package:weektwo/screen/register.dart';
import 'package:weektwo/screen/update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ให้แน่ใจว่า Firebase ถูก initialize ก่อน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ใช้การตั้งค่าจาก firebase_options.dart
  );

  runApp(Myapp()); // เรียกใช้แอปหลังจากที่ Firebase ถูก initialize
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        primaryColor: pColor,
        secondaryHeaderColor: sColor,
      ),
      routes: {
        // 'async': (context) => APIAsync(),
        'dogapi': (context) => dogapi(),
        'login': (context) => Login(),
        'dashboard': (context) => Dashboard(),
        'registor': (context) => Register(),
        'profile': (context) => Profile(),
        'create': (context) => CreateUser(),
        'update': (context) => UpdateUser(userId: '2'),
      },
    );
  }
}
