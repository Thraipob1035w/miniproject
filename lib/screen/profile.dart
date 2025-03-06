import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userData;
  bool _isLoading = false;
  Future<void> getUserAPI() async {
    print('get user');

    final url = Uri.parse('https://reqres.in/api/users/2');
    final response = await http.get(url);
    final responseData = jsonDecode(response.body);
    setState(() {
      userData = responseData['data'];
    });
  }

Future<void> deleteUser() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://reqres.in/api/users/2');
    final response = await http.delete(url);  // ใช้ HTTP DELETE

    if (response.statusCode == 204) {
      setState(() {
        userData = null;  // ลบข้อมูลผู้ใช้หลังจากลบบัญชี
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    print('hello word');
    getUserAPI();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
        backgroundColor: Colors.blue,
      ),
      body: userData == null
          ? const Center(
              child: Text('No data'),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData!['avatar']),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '${userData!['first_name']}${userData!['last_name']}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userData!['email'],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : deleteUser,  // ปิดปุ่มระหว่างโหลด
                      child: _isLoading
                          ? CircularProgressIndicator()  // แสดงการโหลด
                          : const Text('Delete Account'),
                    )
                  ],
                ),
              ),
            ),
            
    );
  }
}
