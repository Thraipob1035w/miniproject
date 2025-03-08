import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeklySummaryPage extends StatefulWidget {
  const WeeklySummaryPage({super.key});

  @override
  State<WeeklySummaryPage> createState() => _WeeklySummaryPageState();
}

class _WeeklySummaryPageState extends State<WeeklySummaryPage> {
  // กำหนดการดึงข้อมูลธุรกรรมจาก Firestore
  Stream<QuerySnapshot> getTransactionsByWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // วันแรกของสัปดาห์
    final endOfWeek = startOfWeek.add(Duration(days: 7)); // วันสุดท้ายของสัปดาห์

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.error('User not authenticated');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: startOfWeek)
        .where('timestamp', isLessThan: endOfWeek)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weekly Summary')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTransactionsByWeek(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
            return Center(child: Text('No transactions for this week.'));
          }

          final transactions = snapshot.data?.docs ?? [];

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
