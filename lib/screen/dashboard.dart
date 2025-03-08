import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้จาก Firebase
  Future<void> _getCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Dashboard")),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // แสดงอีเมลของผู้ใช้ในมุมขวาบน
          _user == null
              ? const CircularProgressIndicator()  // แสดงการโหลดหากยังไม่ได้ดึงข้อมูลผู้ใช้
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _user!.email ?? 'No Email', // แสดงอีเมลผู้ใช้หากมี
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 236, 177, 223),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 100, 184, 253),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                ),
              ),
            ),  ListTile(
              leading: const Icon(Icons.add),
              title: const Text('AddTransactionPage'),
              onTap: () {
                Navigator.pushNamed(context, 'AddTransactionPage');
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.home),
            //   title: const Text('Home'),
            //   onTap: () {
            //     Navigator.pushNamed(context, 'dashboard');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.summarize),
              title: const Text('สรุปผล'),
              onTap: () {
                Navigator.pushNamed(context, 'SummarySelectionPage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
            ),

          
          ],
        ),
      ),
      body: const Center(
        child: Text('Welcome to Dashboard'),
      ),
    );
  }
}
