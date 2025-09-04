import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/services/dummy_data_service.dart';
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
    _testsForExamFuture = _getTestsForCurrentExam();
  }

  // YAHAN BADLAAV KIYA GAYA HAI
  Future<List<Test>> _getTestsForCurrentExam() async {
    final allTests = await DummyDataService().getAllTests();
    // Humne (test) ki jagah (Test test) likha hai taaki type saaf ho jaye
    return allTests.where((Test test) => test.examName == widget.examName).toList();
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

  Widget _buildTierSelection(BuildContext context, List<int> tiers) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: tiers.length,
      itemBuilder: (context, index){
        final tier = tiers[index];
         return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text("Tier $tier", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => _buildTestTypeSelection(context, tier: tier)
              ));
            },
          ),
        );
      }
    );
  }

  Widget _buildTestTypeSelection(BuildContext context, {required int? tier}) {
    final testTypes = ['Mock Tests', 'PYQ Tests'];
    return Scaffold(
      appBar: AppBar(title: Text("${widget.examName} ${tier != null ? '- Tier $tier' : ''}")),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: testTypes.length,
        itemBuilder: (context, index){
          final type = testTypes[index];
           return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(type, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TestListScreen(
                    examName: widget.examName,
                    tier: tier,
                    testType: type == 'Mock Tests' ? 'mock' : 'pyq',
                  ),
                ));
              },
            ),
          );
        }
      ),
    );
  }
}
