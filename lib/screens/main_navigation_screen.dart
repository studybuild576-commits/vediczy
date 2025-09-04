import 'package:flutter/material.dart';
import 'package:vediczy/screens/all_tests_screen.dart';
import 'package:vediczy/screens/home/home_screen.dart';
import 'package:vediczy/screens/revision_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0; // Kaunsa icon select hai

  // Hamari 3 main screens ki list
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    AllTestsScreen(),
    RevisionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), // Select hui screen dikhayein
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Revision',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo, // Active icon ka color
        onTap: _onItemTapped, // Tap karne par function call karein
      ),
    );
  }
}
