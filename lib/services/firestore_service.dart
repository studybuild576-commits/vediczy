import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/models/question_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Test>> getAllTests() async {
    try {
      QuerySnapshot snapshot = await _db.collection('Tests').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Test(
          id: doc.id,
          title: data['title'] ?? '',
          // ... baaki saare fields
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Question>> getQuestionsForTest(String testId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Questions').where('testId', isEqualTo: testId).get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Question(
          id: doc.id,
          testId: data['testId'],
          questionText: data['questionText'] ?? '',
          options: List<String>.from(data['options'] ?? []),
          correctOptionIndex: data['correctOptionIndex'] ?? 0,
          solutionText: data['solutionText'] ?? '',
          subject: data['subject'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
