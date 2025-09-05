import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vediczy/models/question_model.dart';
import 'package:vediczy/models/test_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Test>> getTestsForExam(String examName) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').where('examName', isEqualTo: examName).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Test object बनाते समय सभी ज़रूरी fields यहाँ होने चाहिए
        return Test(
          id: doc.id,
          title: data['title'] ?? 'No Title',
          category: data['category'] ?? '',
          examName: data['examName'] ?? '',
          tier: data['tier'],
          testType: data['testType'] ?? '',
          testFormat: data['testFormat'] ?? '',
          sectionName: data['sectionName'],
          durationInMinutes: data['durationInMinutes'] ?? 60,
          totalMarks: data['totalMarks'] ?? 100,
          description: data['description'] ?? '',
        );
      }).toList();
    } catch (e) {
      print("Error fetching tests for exam: $e");
      return [];
    }
  }

  Future<List<String>> getUniqueExamNamesForCategory(String categoryId) async {
    try {
        QuerySnapshot snapshot = await _db.collection('Tests').where('category', isEqualTo: categoryId).get();
        final tests = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return data['examName'] as String;
        }).toSet().toList();
        return tests;
    } catch (e) {
      print("Error fetching unique exam names: $e");
      return [];
    }
  }

  // ... बाकी के functions जैसे getQuestionsForTest, getAllTests, etc.
}
