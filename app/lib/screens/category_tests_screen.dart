import 'package:flutter/material.dart';

class CategoryTestsScreen extends StatelessWidget {
  final String categoryTitle;
  const CategoryTestsScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        // Abhi ke liye hum yahan ek message dikha rahe hain
        // Baad mein hum yahan us category ke tests ki list dikhayenge
        child: Text(
          'Yahan $categoryTitle ki list aayegi.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
