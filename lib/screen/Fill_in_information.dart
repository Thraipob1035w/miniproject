import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
import 'package:firebase_auth/firebase_auth.dart'; // นำเข้า Firebase Authentication
import 'package:weektwo/screen/SummarySelectionPage.dart';
// import 'summary_selection_page.dart'; // นำเข้าหน้าเลือกสรุป (อย่าลืมสร้างไฟล์นี้)

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'income'; // รายการค่าเริ่มต้น: รายรับ (income)
  double _amount = 0.0;
  String _note = '';

  // ฟังก์ชันสำหรับบันทึกข้อมูลธุรกรรมลงใน Firestore
  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // บันทึกค่าจากฟอร์ม

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // เรียกใช้ฟังก์ชันที่เพิ่มธุรกรรมลงใน Firestore
        await FirebaseFirestore.instance
            .collection('users') // ใช้ collection 'users'
            .doc(user.uid) // ใช้ user.uid เพื่อเก็บข้อมูลธุรกรรมของผู้ใช้
            .collection('transactions') // ใช้ subcollection 'transactions'
            .add({
          'type': _transactionType,
          'amount': _amount,
          'note': _note,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction added successfully!')),
        );

        // เปลี่ยนไปยังหน้าตัวเลือกผลสรุปโดยทันที
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SummarySelectionPage()), // ให้ไปที่หน้าตัวเลือก
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is logged in!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _transactionType,
                items: [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (value) {
                  setState(() {
                    _transactionType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Transaction Type'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.tryParse(value!) ?? 0.0;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Note'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
                onSaved: (value) {
                  _note = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
