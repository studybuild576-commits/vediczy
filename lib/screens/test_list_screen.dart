import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/test/test_instructions_screen.dart';
import 'package:vediczy/services/dummy_data_service.dart';

class TestListScreen extends StatefulWidget {
  final String examName;
  final int? tier;
  final String testType;

  const TestListScreen({super.key, required this.examName, this.tier, required this.testType});

  @override
  _TestListScreenState createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  late Future<List<Test>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = DummyDataService().getTestsByFilter(
      examName: widget.examName,
      tier: widget.tier,
      testType: widget.testType,
    );
  }

  @override
  Widget build(BuildContext context) {
    String testTypeTitle = widget.testType == 'mock' ? 'Mock Tests' : 'PYQ Tests';
    return Scaffold(
      appBar: AppBar(title: Text("${widget.examName} - $testTypeTitle")),
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No tests found."));
          }
          final tests = snapshot.data!;
          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(test.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text("${test.durationInMinutes} Mins | ${test.totalMarks} Marks"),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TestInstructionsScreen(test: test),
                      ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
