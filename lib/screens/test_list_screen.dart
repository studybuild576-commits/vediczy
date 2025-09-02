import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'realistic_cbt_test_screen.dart'; // Nayi screen ka import

class TestListScreen extends StatelessWidget {
  final Exam exam;
  const TestListScreen({super.key, required this.exam});

  final List<String> testTypes = const [
    'Model Test',
    'PYQ Test',
    'Sectional Test',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${exam.name} - Tests'),
      ),
      body: ListView.builder(
        itemCount: testTypes.length,
        itemBuilder: (context, index) {
          final testType = testTypes[index];
          return ListTile(
            title: Text(testType),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RealisticCBTTestScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
