import 'package:vediczy/models/test_model.dart';
// Note: Apne project ka naam (vediczy) check kar lein

class DummyDataService {

  // Mock Tests ki ek nakli list
  final List<Test> _dummyTests = [
    Test(
      id: 'ssc-cgl-mock-1',
      title: 'SSC CGL Tier-1 Full Mock Test',
      description: 'Based on the latest 2025 pattern with all new questions.',
      durationInMinutes: 60,
      totalMarks: 200,
      examName: 'SSC CGL Tier-1',
    ),
    Test(
      id: 'rrb-ntpc-mock-1',
      title: 'RRB NTPC CBT-1 Mock Test',
      description: 'High-level questions for comprehensive practice.',
      durationInMinutes: 90,
      totalMarks: 100,
      examName: 'RRB NTPC',
    ),
    Test(
      id: 'ssc-chsl-mock-1',
      title: 'SSC CHSL Previous Year Paper 2024',
      description: 'Solve the actual paper from the last exam.',
      durationInMinutes: 60,
      totalMarks: 200,
      examName: 'SSC CHSL',
    ),
  ];

  // Function jo saare dummy tests return karega
  Future<List<Test>> getAllTests() async {
    // Asli app mein yahan Firestore se data aayega.
    // Abhi ke liye hum bas 1 second ka delay daal rahe hain.
    await Future.delayed(Duration(seconds: 1));
    return _dummyTests;
  }

  // Aap yahan dummy questions ke liye bhi function bana sakte hain
}
