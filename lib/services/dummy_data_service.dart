import 'package:vediczy/models/question_model.dart'; // Is line ko upar add karein
import 'package:vediczy/models/test_model.dart';

class DummyDataService {

  // ... aapka purana getAllTests() function yahan hai ...
  final List<Test> _dummyTests = [ /* ... purana data ... */ ];
  Future<List<Test>> getAllTests() async { /* ... purana code ... */ }

  // YEH NAYA FUNCTION ADD KAREIN
  Future<List<Question>> getQuestionsForTest(String testId) async {
    await Future.delayed(Duration(seconds: 1));
    // Hum har test ke liye same 5 dummy questions bhej rahe hain
    // Asli app mein, yeh testId ke hisab se Firestore se aayenge
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
