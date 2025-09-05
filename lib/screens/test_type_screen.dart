// lib/services/firestore_service.dart

class FirestoreService {
  // ... aapka purana code ...

  // YEH NAYA FUNCTION ADD KAREIN
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

  // ... baaki purana code ...
}
