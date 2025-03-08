import 'package:flutter/material.dart';
import 'package:weektwo/screen/DailySummaryPage.dart';
import 'package:weektwo/screen/MonthlySummaryPage.dart';
import 'package:weektwo/screen/WeeklySummaryPage.dart';
// import 'package:weektwo/screen/daily_summary.dart';
// import 'package:weektwo/screen/weekly_summary.dart';
// import 'package:weektwo/screen/monthly_summary.dart';

class SummarySelectionPage extends StatelessWidget {
  const SummarySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailySummaryPage()),
                );
              },
              child: Text('Daily Summary'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeeklySummaryPage()),
                );
              },
              child: Text('Weekly Summary'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonthlySummaryPage()),
                );
              },
              child: Text('Monthly Summary'),
            ),
          ],
        ),
      ),
    );
  }
}
