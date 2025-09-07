import 'package:flutter/material.dart';
import 'package:vediczy_admin/screens/dashboard_screen.dart';
import 'package:vediczy_admin/screens/manage_revision_screen.dart';
import 'package:vediczy_admin/screens/manage_tests_screen.dart';

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
        title: const Text("Vediczy Admin Panel"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _navigateTo(DashboardScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Manage Tests'),
              onTap: () => _navigateTo(ManageTestsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
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
