import 'package:flutter/material.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/test/test_screen.dart';
import 'package:vediczy/services/ad_service.dart'; // AdService को इम्पोर्ट करें

class TestInstructionsScreen extends StatefulWidget {
  final Test test;
  const TestInstructionsScreen({super.key, required this.test});

  @override
  State<TestInstructionsScreen> createState() => _TestInstructionsScreenState();
}

class _TestInstructionsScreenState extends State<TestInstructionsScreen> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    // स्क्रीन खुलते ही विज्ञापन लोड करना शुरू करें
    _adService.loadInterstitialAd();
  }

  // टेस्ट स्क्रीन पर जाने के लिए एक अलग फंक्शन
  void _navigateToTestScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TestScreen(test: widget.test)),
    );
  }

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
              widget.test.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.test.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Divider(height: 40, thickness: 1),

            // Instructions section
            Text(
              'Instructions:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            _buildInstructionRow(context, Icons.timer_outlined, 'Duration:', '${widget.test.durationInMinutes} Minutes'),
            SizedBox(height: 10),
            _buildInstructionRow(context, Icons.format_list_numbered, 'Total Questions:', '${(widget.test.totalMarks / 2).round()}'),
            SizedBox(height: 10),
            _buildInstructionRow(context, Icons.check_circle_outline, 'Total Marks:', '${widget.test.totalMarks}'),

            Spacer(), 

            // Start Test Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // पहले विज्ञापन दिखाएँ, और विज्ञापन बंद होने के बाद टेस्ट स्क्रीन पर जाएँ
                _adService.showInterstitialAd(onAdDismissed: () {
                  _navigateToTestScreen();
                });
              },
              child: Text('Start Test'),
            ),
          ],
        ),
      ),
    );
  }

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
