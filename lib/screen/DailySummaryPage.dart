import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailySummaryPage extends StatefulWidget {
  const DailySummaryPage({super.key});

  @override
  State<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  // กำหนดการดึงข้อมูลธุรกรรมจาก Firestore
  Stream<QuerySnapshot> getTransactionsByDay() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.error('User not authenticated');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Summary')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTransactionsByDay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
            return Center(child: Text('No transactions for today.'));
          }

          final transactions = snapshot.data?.docs ?? [];

          // คำนวณผลรวมรายรับและรายจ่าย
          double totalIncome = 0;
          double totalExpense = 0;

          for (var transaction in transactions) {
            if (transaction['type'] == 'income') {
              totalIncome += transaction['amount'];
            } else if (transaction['type'] == 'expense') {
              totalExpense += transaction['amount'];
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Income: \$${totalIncome.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total Expense: \$${totalExpense.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
