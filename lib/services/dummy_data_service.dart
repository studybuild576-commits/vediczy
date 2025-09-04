import 'package:vediczy/models/question_model.dart';
import 'package:vediczy/models/test_model.dart';

class DummyDataService {

  // Mock Tests ki ek nakli list
  final List<Test> _dummyTests = [
    Test(
      id: 'ssc-cgl-mock-1',
      title: 'SSC CGL Tier-1 Full Mock Test',
      description: 'Based on the latest pattern with all new questions.',
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
    await Future.delayed(Duration(seconds: 1));
    return _dummyTests;
  }

  // Function jo ek test ke saare questions return karega
  Future<List<Question>> getQuestionsForTest(String testId) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Question(
        id: 'q1', testId: testId, subject: 'General Awareness',
        questionText: 'What is the capital of India?',
        options: ['Mumbai', 'Kolkata', 'New Delhi', 'Chennai'],
        correctOptionIndex: 2,
        solutionText: 'New Delhi is the capital of India.'
      ),
      Question(
        id: 'q2', testId: testId, subject: 'Maths',
        questionText: 'What is 2 + 2 * 2?',
        options: ['8', '6', '4', '10'],
        correctOptionIndex: 1,
        solutionText: 'According to BODMAS rule, 2 * 2 = 4, then 4 + 2 = 6.'
      ),
      Question(
        id: 'q3', testId: testId, subject: 'Reasoning',
        questionText: 'Which number comes next in the series: 2, 4, 6, 8, __?',
        options: ['9', '10', '12', '5'],
        correctOptionIndex: 1,
        solutionText: 'This is a simple series of even numbers.'
      ),
      Question(
        id: 'q4', testId: testId, subject: 'English',
        questionText: 'What is the synonym of "Happy"?',
        options: ['Sad', 'Joyful', 'Angry', 'Tired'],
        correctOptionIndex: 1,
        solutionText: 'Joyful is a word with a similar meaning to Happy.'
      ),
      Question(
        id: 'q5', testId: testId, subject: 'General Awareness',
        questionText: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
        correctOptionIndex: 1,
        solutionText: 'Mars is known as the Red Planet due to its reddish appearance.'
      ),
    ];
  }
}
