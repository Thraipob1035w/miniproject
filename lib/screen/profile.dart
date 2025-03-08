import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? email; // เก็บอีเมลจาก Firebase Authentication
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลอีเมลหลังจากที่ผู้ใช้ล็อกอิน
    getUserEmail();
  }

  Future<void> getUserEmail() async {
    try {
      // ตรวจสอบว่าผู้ใช้ล็อกอินอยู่หรือไม่
      User? user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        setState(() {
          email = user.email;  // เก็บอีเมลของผู้ใช้ที่ล็อกอินแล้ว
        });
      } else {
        // หากไม่ได้ล็อกอิน จะไม่สามารถดึงข้อมูลได้
        print('No user is logged in');
      }
    } catch (error) {
      print('Error getting user email: $error');
    }
  }

  // ฟังก์ชันสำหรับล็อกเอ้าท์ผู้ใช้
  Future<void> signOutUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ทำการล็อกเอ้าท์ผู้ใช้จาก Firebase
      await FirebaseAuth.instance.signOut();
      setState(() {
        email = null; // ลบข้อมูลผู้ใช้ใน UI
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out successfully')),
      );
      // หลังจากล็อกเอ้าท์แล้วให้กลับไปที่หน้าล็อคอิน
      Navigator.pushReplacementNamed(context, 'login');  // ไปที่หน้าล็อกอิน
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        backgroundColor: Colors.blue,
      ),
      body: email == null
          ? const Center(child: CircularProgressIndicator())  // รอการดึงข้อมูล
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile.jpg'), // ใช้ภาพโปรไฟล์
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email: $email',  // แสดงอีเมล
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : signOutUser,  // เมื่อกำลังโหลดจะไม่สามารถคลิกได้
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : const Text('Log Out'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
