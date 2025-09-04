import 'package:flutter/material.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/test/test_screen.dart';

class TestInstructionsScreen extends StatelessWidget {
  final Test test;

  // Constructor se hum pichli screen se test ki details lenge
  const TestInstructionsScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              test.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Divider(height: 40, thickness: 1),

            // Instructions section
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            _buildInstructionRow(context, Icons.timer_outlined, 'Duration:', '${test.durationInMinutes} Minutes'),
            SizedBox(height: 10),
            _buildInstructionRow(context, Icons.format_list_numbered, 'Total Questions:', '${(test.totalMarks / 2).round()}'), // Assuming 2 marks per question
            SizedBox(height: 10),
            _buildInstructionRow(context, Icons.check_circle_outline, 'Total Marks:', '${test.totalMarks}'),

            Spacer(), // Bachi hui jagah le lega

            // Start Test Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Test Screen par navigate karein aur 'test' object pass karein
                Navigator.pushReplacement( // pushReplacement taaki user wapas instructions par na aa sake
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestScreen(test: test),
                  ),
                );
              },
              child: Text('Start Test'),
            ),
          ],
        ),
      ),
    );
  }

  // Chota helper widget instructions ko sundar dikhane ke liye
  Widget _buildInstructionRow(BuildContext context, IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        SizedBox(width: 15),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 5),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
