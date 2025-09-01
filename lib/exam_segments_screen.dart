import 'package:flutter/material.dart';
import 'package:vediczy/screens/cbt_test_screen.dart';

class ExamSegmentsScreen extends StatelessWidget {
  final String examName;

  const ExamSegmentsScreen({super.key, required this.examName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSegmentCard(context, 'Model Test', Colors.lightBlue),
            _buildSegmentCard(context, 'PYQ Test', Colors.teal),
            _buildSegmentCard(context, 'Revision', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentCard(BuildContext context, String segmentName, Color color) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to CBT Test screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CbtTestScreen(
                  title: '$segmentName for $examName',
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                segmentName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
