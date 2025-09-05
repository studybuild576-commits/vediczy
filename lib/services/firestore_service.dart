import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vediczy/models/question_model.dart';
import 'package:vediczy/models/test_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<String>> getUniqueExamNamesForCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').where('category', isEqualTo: categoryId).get();
      final examNames = snapshot.docs.map((doc) {
        return (doc.data() as Map<String, dynamic>)['examName'] as String;
      }).toSet().toList();
      return examNames;
    } catch (e) {
      print("Error fetching unique exam names: $e");
      return [];
    }
  }

  Future<List<Test>> getTestsForExam(String examName) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').where('examName', isEqualTo: examName).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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

  Future<List<Test>> getTestsByFilter({required String examName, int? tier, required String testType}) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests')
          .where('examName', isEqualTo: examName)
          .where('tier', isEqualTo: tier)
          .where('testType', isEqualTo: testType)
          .get();
          
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Test.fromFirestore(data, doc.id); // Assuming you have a fromFirestore constructor
      }).toList();
    } catch (e) {
      print("Error fetching tests by filter: $e");
      return [];
    }
  }

  Future<List<Question>> getQuestionsForTest(String testId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Questions').where('testId', isEqualTo: testId).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Question.fromFirestore(data, doc.id); // Assuming fromFirestore
      }).toList();
    } catch (e) {
      print("Error fetching questions: $e");
      return [];
    }
  }
}

// NOTE: Add these fromFirestore constructors to your model files
// In test_model.dart
/*
  factory Test.fromFirestore(Map<String, dynamic> data, String id) {
    return Test(
      id: id,
      title: data['title'] ?? 'No Title',
      // ... other fields
    );
  }
*/

// In question_model.dart
/*
  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      questionText: data['questionText'] ?? '',
      // ... other fields
    );
  }
*/
