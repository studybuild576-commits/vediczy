import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vediczy/models/question_model.dart';
import 'package:vediczy/models/test_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // सैंपल डेटा जोड़ने का फंक्शन
  Future<void> addSampleData() async {
    try {
      print("Adding sample data to Firestore...");
      DocumentReference testRef = await _db.collection('Tests').add({
        'title': 'New SSC MTS Mock Test',
        'description': 'A new sample test added from the app.',
        'durationInMinutes': 90,
        'totalMarks': 150,
        'examName': 'SSC MTS',
        'category': 'ssc',
        'tier': null,
        'testType': 'mock',
        'testFormat': 'full',
        'isActive': true,
      });

      String newTestId = testRef.id;
      print("New Test created with ID: $newTestId");

      final questions = [
        {'testId': newTestId, 'questionText': 'Which is the largest planet?', 'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'], 'correctOptionIndex': 2, 'solutionText': 'Jupiter is the largest planet.', 'subject': 'General Science',},
        {'testId': newTestId, 'questionText': 'What is 15 * 3?', 'options': ['40', '45', '50', '55'], 'correctOptionIndex': 1, 'solutionText': '15 multiplied by 3 is 45.', 'subject': 'Maths',}
      ];

      for (var question in questions) {
        await _db.collection('Questions').add(question);
      }
      print("✅ Sample data added successfully!");

    } catch (e) {
      print("❌ Error adding sample data: $e");
    }
  }

  // श्रेणी के अनुसार परीक्षा के नाम प्राप्त करें
  Future<List<String>> getUniqueExamNamesForCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').where('category', isEqualTo: categoryId).get();
      final examNames = snapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)['examName'] as String).toSet().toList();
      return examNames;
    } catch (e) {
      return [];
    }
  }

  // परीक्षा के नाम के अनुसार टेस्ट प्राप्त करें
  Future<List<Test>> getTestsForExam(String examName) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').where('examName', isEqualTo: examName).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Test(id: doc.id, title: data['title'] ?? '', category: data['category'] ?? '', examName: data['examName'] ?? '', tier: data['tier'], testType: data['testType'] ?? '', testFormat: data['testFormat'] ?? '', sectionName: data['sectionName'], durationInMinutes: data['durationInMinutes'] ?? 0, totalMarks: data['totalMarks'] ?? 0, description: data['description'] ?? '');
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // एक टेस्ट के प्रश्न प्राप्त करें
  Future<List<Question>> getQuestionsForTest(String testId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Questions').where('testId', isEqualTo: testId).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Question(id: doc.id, testId: data['testId'] ?? '', questionText: data['questionText'] ?? '', options: List<String>.from(data['options'] ?? []), correctOptionIndex: data['correctOptionIndex'] ?? 0, solutionText: data['solutionText'] ?? '', subject: data['subject'] ?? '');
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
