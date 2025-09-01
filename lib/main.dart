import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Please make sure 'google_sign_in_page.dart' file
// 'lib/screens' folder ke andar hi saved hai.
// If you want to use the full code in a single file, you can move the content of 'google_sign_in_page.dart' here.
// For demonstration, I will include the content of the GoogleSignInPage here.

// Your GoogleSignInPage code here
class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      // Handle the error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGoogle,
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
// End of GoogleSignInPage code

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSC Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExamCard(context, 'SSC CGL'),
            _buildExamCard(context, 'SSC CHSL'),
            _buildExamCard(context, 'SSC GD'),
            _buildExamCard(context, 'SSC MTS'),
            _buildExamCard(context, 'SSC CPO'),
            // Add more exams as needed
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, String examName) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          examName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ExamSegmentsScreen(examName: examName)),
          );
        },
      ),
    );
  }
}

// Exam Segments Screen
class ExamSegmentsScreen extends StatelessWidget {
  final String examName;

  const ExamSegmentsScreen({super.key, required this.examName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSegmentCard(context, 'Model Test', Colors.lightBlue),
            _buildSegmentCard(context, 'PYQ Test', Colors.teal),
            _buildSegmentCard(context, 'Revision', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentCard(BuildContext context, String segmentName, Color color) {
    return Expanded(
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to CBT Test screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CbtTestScreen(
                  title: '$segmentName for $examName',
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                segmentName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// CBT Test Screen
class CbtTestScreen extends StatefulWidget {
  final String title;

  const CbtTestScreen({super.key, required this.title});

  @override
  _CbtTestScreenState createState() => _CbtTestScreenState();
}

class QuestionModel {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  int userSelectedOptionIndex = -1;
  bool isMarkedForReview = false;

  QuestionModel({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });
}

class _CbtTestScreenState extends State<CbtTestScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 3;

  final List<QuestionModel> _questions = [
    QuestionModel(
      questionText: 'What is the capital of India?',
      options: ['Mumbai', 'Delhi', 'Kolkata', 'Chennai'],
      correctOptionIndex: 1,
    ),
    QuestionModel(
      questionText: 'Who is the first Prime Minister of India?',
      options: ['Jawaharlal Nehru', 'Sardar Patel', 'B.R. Ambedkar', 'Mahatma Gandhi'],
      correctOptionIndex: 0,
    ),
    QuestionModel(
      questionText: 'Which is the largest country by area?',
      options: ['Russia', 'Canada', 'China', 'USA'],
      correctOptionIndex: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentQuestionIndex = _pageController.page!.round();
      });
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _showTestSubmitDialog();
    }
  }

  void _markForReview() {
    setState(() {
      _questions[_currentQuestionIndex].isMarkedForReview = true;
      _nextQuestion();
    });
  }

  void _clearResponse() {
    setState(() {
      _questions[_currentQuestionIndex].userSelectedOptionIndex = -1;
    });
  }

  Color _getQuestionStatusColor(int index) {
    if (_questions[index].isMarkedForReview) {
      return Colors.purple; // Marked for Review
    } else if (_questions[index].userSelectedOptionIndex != -1) {
      return Colors.green; // Answered
    }
    return Colors.grey; // Not Answered
  }

  void _showTestSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test Complete'),
          content: const Text('Are you sure you want to submit the test?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () {},
          ),
          const Text('00:30', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Left panel for questions
          Container(
            width: 100,
            color: Colors.grey[200],
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getQuestionStatusColor(index),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Right panel for the current question
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}:',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.questionText,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ...question.options.map((option) {
                        int optionIndex = question.options.indexOf(option);
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(option),
                            leading: Radio<int>(
                              value: optionIndex,
                              groupValue: question.userSelectedOptionIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  question.userSelectedOptionIndex = value!;
                                  question.isMarkedForReview = false;
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                question.userSelectedOptionIndex = optionIndex;
                                question.isMarkedForReview = false;
                              });
                            },
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _clearResponse,
                            child: const Text('Clear Response'),
                          ),
                          ElevatedButton(
                            onPressed: _markForReview,
                            child: const Text('Mark for Review & Next'),
                          ),
                          ElevatedButton(
                            onPressed: _nextQuestion,
                            child: const Text('Save & Next'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showTestSubmitDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit Test'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// End of CBT Test Screen


// Splash Screen - This is needed to avoid import errors
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can add your app logo here
            const FlutterLogo(size: 150),
            const SizedBox(height: 20),
            const Text(
              'SSC Education App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// End of Splash Screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSC Education App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const DashboardScreen();
        }
        return const GoogleSignInPage();
      },
    );
  }
}
