import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>(); // สำหรับตรวจสอบการกรอกฟอร์ม
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  // ฟังก์ชันสำหรับการสร้างผู้ใช้ใหม่
  Future<void> _createUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://reqres.in/api/users');

      // ส่งข้อมูลในรูปแบบ JSON
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': _nameController.text,
          'job': _jobController.text,
        }),
      );

      if (response.statusCode == 201) {
        // หากตอบกลับสำเร็จ (สถานะ 201 Created)
        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Created: ${responseData['id']}')),
        );
      } else {
        // หากเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
        backgroundColor: const Color.fromARGB(255, 80, 147, 202),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // เชื่อมต่อกับ _formKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
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
                    return 'Please enter a job';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createUser, // เรียกฟังก์ชันเมื่อกดปุ่ม
                child: const Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
