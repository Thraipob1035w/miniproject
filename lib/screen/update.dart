import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateUser extends StatefulWidget {
  final String userId; // รับ userId จาก argument

  const UpdateUser({super.key, required this.userId});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  // ฟังก์ชันดึงข้อมูลผู้ใช้ปัจจุบัน
  Future<void> _fetchUserData() async {
    final url = Uri.parse('https://reqres.in/api/users/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['data'];
      // ตั้งค่าฟิลด์ให้มีข้อมูลเดิมที่ดึงมาจาก API
      _nameController.text = responseData['first_name']; // หรือเปลี่ยนตามที่ต้องการ
      _jobController.text = responseData['job']; // อัปเดต job ถ้ามีข้อมูลนี้
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  // ฟังก์ชันอัปเดตข้อมูลผู้ใช้
  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://reqres.in/api/users/${widget.userId}');

      // ส่งข้อมูลที่อัปเดตไปยัง API
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': _nameController.text,
          'job': _jobController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Updated: ${responseData['name']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // ดึงข้อมูลผู้ใช้เมื่อตัว Widget ถูกสร้าง
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(labelText: 'Job'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your job';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateUser, // เรียกฟังก์ชันอัปเดตผู้ใช้
                child: const Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
