import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Dashboard")),
        leading: Builder(
            builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                })),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
               Navigator.pushNamed(context, 'profile');
            },
          )
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
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                 Navigator.pushNamed(context, 'login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, 'profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('create'),
              onTap: () {
                Navigator.pushNamed(context, 'create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Update'),
              onTap: () {
                 Navigator.pushNamed(context, 'update');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('delete'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('dashboard'),
      ),
    );
  }
}
