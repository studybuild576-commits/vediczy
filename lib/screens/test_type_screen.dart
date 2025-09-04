import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/services/dummy_data_service.dart';
import 'package:vediczy/screens/test_list_screen.dart'; // Nayi screen import

class TestTypeScreen extends StatelessWidget {
  final String examName;
  const TestTypeScreen({super.key, required this.examName});

  @override
  Widget build(BuildContext context) {
    // Hum dummy data se check karenge ki is exam ke tiers hain ya nahi.
    // Asli app mein yeh jaankari exam ke document se aayegi.
    bool hasTiers = DummyDataService()._dummyTests.any((test) => test.examName == examName && test.tier != null);

    return Scaffold(
      appBar: AppBar(title: Text(examName)),
      body: hasTiers
          ? _buildTierSelection(context)
          : _buildTestTypeSelection(context, tier: null),
    );
  }

  Widget _buildTierSelection(BuildContext context) {
    // Unique tiers nikalna
    final tiers = DummyDataService()._dummyTests
        .where((test) => test.examName == examName && test.tier != null)
        .map((test) => test.tier!)
        .toSet().toList();

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
      appBar: AppBar(title: Text("$examName ${tier != null ? '- Tier $tier' : ''}")),
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
                    examName: examName,
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
