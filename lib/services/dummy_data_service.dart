import 'package.vediczy/models/question_model.dart';
import 'package.vediczy/models/test_model.dart';

class DummyDataService {

  final List<Test> _dummyTests = [
    // --- SSC Exams ---
    Test(id: 'ssc-cgl-t1-mock-1', title: 'SSC CGL Tier-1 Full Mock #1', category: 'ssc', examName: 'SSC CGL', tier: 1, testType: 'mock', testFormat: 'full', durationInMinutes: 60, totalMarks: 200, description: 'Latest pattern CGL Tier-1 mock.'),
    Test(id: 'ssc-cgl-t1-pyq-1', title: 'SSC CGL Tier-1 PYQ (2024)', category: 'ssc', examName: 'SSC CGL', tier: 1, testType: 'pyq', testFormat: 'full', durationInMinutes: 60, totalMarks: 200, description: 'Previous year paper for CGL Tier-1.'),
    Test(id: 'ssc-cgl-t2-mock-1', title: 'SSC CGL Tier-2 Full Mock #1', category: 'ssc', examName: 'SSC CGL', tier: 2, testType: 'mock', testFormat: 'full', durationInMinutes: 120, totalMarks: 390, description: 'Latest pattern CGL Tier-2 mock.'),
    Test(id: 'ssc-chsl-t1-mock-1', title: 'SSC CHSL Tier-1 Mock #1', category: 'ssc', examName: 'SSC CHSL', tier: 1, testType: 'mock', testFormat: 'full', durationInMinutes: 60, totalMarks: 200, description: 'Latest pattern CHSL mock.'),
    Test(id: 'ssc-mts-mock-1', title: 'SSC MTS Full Mock Test #1', category: 'ssc', examName: 'SSC MTS', tier: null, testType: 'mock', testFormat: 'full', durationInMinutes: 90, totalMarks: 150, description: 'Practice test for SSC MTS.'),
    Test(id: 'ssc-gd-mock-1', title: 'SSC GD Constable Mock #1', category: 'ssc', examName: 'SSC GD Constable', tier: null, testType: 'mock', testFormat: 'full', durationInMinutes: 60, totalMarks: 160, description: 'Practice test for GD Constable.'),
    // --- Railway Exams ---
    Test(id: 'rrb-ntpc-cbt1-mock-1', title: 'RRB NTPC CBT-1 Full Mock', category: 'railway', examName: 'RRB NTPC', tier: 1, testType: 'mock', testFormat: 'full', durationInMinutes: 90, totalMarks: 100, description: 'Practice for NTPC CBT-1.'),
    Test(id: 'rrb-ntpc-cbt2-mock-1', title: 'RRB NTPC CBT-2 Full Mock', category: 'railway', examName: 'RRB NTPC', tier: 2, testType: 'mock', testFormat: 'full', durationInMinutes: 90, totalMarks: 120, description: 'Practice for NTPC CBT-2.'),
    Test(id: 'rrb-groupd-mock-1', title: 'RRB Group D Mock Test #1', category: 'railway', examName: 'RRB Group D', tier: null, testType: 'mock', testFormat: 'full', durationInMinutes: 90, totalMarks: 100, description: 'Practice test for RRB Group D.'),
    Test(id: 'rrb-alp-cbt1-mock-1', title: 'RRB ALP CBT-1 Mock Test', category: 'railway', examName: 'RRB ALP', tier: 1, testType: 'mock', testFormat: 'full', durationInMinutes: 60, totalMarks: 75, description: 'Practice for ALP CBT-1.'),
  ];

  Future<List<Test>> getAllTests() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _dummyTests;
  }

  Future<List<String>> getUniqueExamNamesForCategory(String categoryId) async {
    final allTests = await getAllTests();
    final filteredTests = allTests.where((test) => test.category == categoryId).toList();
    final uniqueExamNames = filteredTests.map((test) => test.examName).toSet().toList();
    return uniqueExamNames;
  }

  Future<List<Test>> getTestsByFilter({required String examName, int? tier, required String testType}) async {
    final allTests = await getAllTests();
    return allTests.where((test) {
      return test.examName == examName && test.tier == tier && test.testType == testType;
    }).toList();
  }

  // getQuestionsForTest() function waise hi rahega
  Future<List<Question>> getQuestionsForTest(String testId) async {
    // ...
  }
}
