import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/models/test_model.dart'; // यह इम्पोर्ट ज़रूरी है
import 'package:vediczy/services/firestore_service.dart';
import 'package:vediczy/screens/test_list_screen.dart';

class TestTypeScreen extends StatefulWidget {
  final String examName;
  const TestTypeScreen({super.key, required this.examName});

  @override
  _TestTypeScreenState createState() => _TestTypeScreenState();
}

class _TestTypeScreenState extends State<TestTypeScreen> {
  late Future<List<Test>> _testsForExamFuture;

  @override
  void initState() {
    super.initState();
    _testsForExamFuture = FirestoreService().getTestsForExam(widget.examName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.examName)),
      body: FutureBuilder<List<Test>>(
        future: _testsForExamFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No tests found for this exam."));
          }

          final testsForThisExam = snapshot.data!;
          bool hasTiers = testsForThisExam.any((test) => test.tier != null);

          if (hasTiers) {
            final tiers = testsForThisExam
                .where((test) => test.tier != null)
                .map((test) => test.tier!)
                .toSet().toList();
            tiers.sort();
            return _buildTierSelection(context, tiers);
          } else {
            return _buildTestTypeSelection(context, tier: null);
          }
        },
      ),
    );
  }
  // ... (बाकी के _buildTierSelection और _buildTestTypeSelection विजेट्स यहाँ रहेंगे)
}
