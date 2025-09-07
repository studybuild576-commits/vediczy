import 'package:flutter/material.dart';
import 'package:vediczy_admin/screens/dashboard_screen.dart';
import 'package:vediczy_admin/screens/manage_tests_screen.dart';
import 'package:vediczy_admin/screens/manage_revision_screen.dart'; // नया इम्पोर्ट

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Widget _currentPage = DashboardScreen();

  void _navigateTo(Widget page) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vediczy Admin Panel"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _navigateTo(DashboardScreen()),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: const Text('Manage Tests'),
              onTap: () => _navigateTo(ManageTestsScreen()),
            ),
            // YEH NAYA MENU ITEM HAI
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: const Text('Manage Revision'),
              onTap: () => _navigateTo(ManageRevisionScreen()),
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }
}
