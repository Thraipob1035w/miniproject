import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // นำเข้า firebase_core
import 'package:weektwo/screen/Fill_in_information.dart';
import 'package:weektwo/screen/SummarySelectionPage.dart';
// import 'package:weektwo/screen/home.dart';
import 'package:weektwo/screen/login.dart';
// import 'package:weektwo/screen/login.dart';
import 'firebase_options.dart'; // นำเข้า firebase_options.dart
import 'package:weektwo/constant/constant.dart';

// import 'package:weektwo/screen/create.dart';
import 'package:weektwo/screen/dashboard.dart';
// import 'package:weektwo/screen/dogapi.dart';

import 'package:weektwo/screen/profile.dart';
import 'package:weektwo/screen/register.dart';
// import 'package:weektwo/screen/update.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า cloud_firestore สำหรับ Firestore

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ให้แน่ใจว่า Firebase ถูก initialize ก่อน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // ใช้การตั้งค่าจาก firebase_options.dart
  );

  runApp(Myapp()); // เรียกใช้แอปหลังจากที่ Firebase ถูก initialize
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      theme: ThemeData(
        primaryColor: pColor,
        secondaryHeaderColor: sColor,
      ),
      routes: {
        // 'async': (context) => APIAsync(),
        // 'dogapi': (context) => dogapi(),
        'login': (context) => Login(),
        'dashboard': (context) => Dashboard(),
        'registor': (context) => Register(),
        'profile': (context) => Profile(),
        // 'create': (context) => CreateUser(),
        // 'update': (context) => UpdateUser(userId: '2'),
        'AddTransactionPage': (context) => AddTransactionPage(),
        'SummarySelectionPage': (context) => SummarySelectionPage(),
      },
    );
  }
}

// ฟังก์ชันสำหรับเพิ่มข้อมูลธุรกรรมลงใน Firestore
Future<void> addTransaction(String type, double amount, String note) async {
  // เพิ่มเอกสารใหม่ไปยัง collection 'transactions'
  await FirebaseFirestore.instance.collection('transactions').add({
    'type': type, // ประเภท: รายรับ ('income') หรือรายจ่าย ('expense')
    'amount': amount, // จำนวนเงิน
    'note': note, // หมายเหตุ
    'timestamp': FieldValue.serverTimestamp(), // เวลาที่บันทึก
  });
}

// ฟังก์ชันสำหรับดึงข้อมูลธุรกรรมทั้งหมดจาก Firestore
Stream<QuerySnapshot> getTransactions() {
  return FirebaseFirestore.instance.collection('transactions').snapshots();
}

// ฟังก์ชันสำหรับลบข้อมูลธุรกรรมจาก Firestore โดยใช้ document ID
Future<void> deleteTransaction(String docId) async {
  await FirebaseFirestore.instance
      .collection('transactions')
      .doc(docId)
      .delete();
}

// ฟังก์ชันสำหรับอัปเดตข้อมูลธุรกรรมใน Firestore
Future<void> updateTransaction(
    String docId, Map<String, dynamic> newData) async {
  await FirebaseFirestore.instance
      .collection('transactions')
      .doc(docId)
      .update(newData);
}
