     import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../widgets/question_widget.dart';
import '../widgets/question_palette.dart';
import '../widgets/top_bar.dart';

class TestScreen extends StatefulWidget {
  final Exam exam;
  final String testType;

  const TestScreen({super.key, required this.exam, required this.testType});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int currentQuestionIndex = 0;
  bool isMarkForReview = false;
  bool isHindi = false;

  late Timer _timer;
  Duration timeRemaining = const Duration(minutes: 30);

  late List<Question> questions;
  late List<int?> selectedOptions;
  late List<bool> markedForReview;

  @override
  void initState() {
    super.initState();
    questions = _loadDummyQuestions();
    selectedOptions = List<int?>.filled(questions.length, null);
    markedForReview = List<bool>.filled(questions.length, false);
    _startTimer();
  }

  List<Question> _loadDummyQuestions() {
    return [
      Question(
        id: 'q1',
        textEn: 'What is 2 + 2?',
        textHi: '2 + 2 कितना होता है?',
        optionsEn: ['1', '2', '3', '4'],
        optionsHi: ['1', '2', '3', '4'],
        correctIndex: 3,
        explanation: '2 + 2 equals 4.',
        negativeMark: 0.25,
      ),
      Question(
        id: 'q2',
        textEn: 'What is the capital of India?',
        textHi: 'भारत की राजधानी क्या है?',
        optionsEn: ['New Delhi', 'Mumbai', 'Kolkata', 'Chennai'],
        optionsHi: ['नई दिल्ली', 'मुंबई', 'कोलकाता', 'चेन्नई'],
        correctIndex: 0,
        explanation: 'Capital of India is New Delhi.',
        negativeMark: 0.25,
      ),
    ];
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.inSeconds == 0) {
        timer.cancel();
        _submitTest();
      } else {
        setState(() {
          timeRemaining = timeRemaining - const Duration(seconds: 1);
        });
      }
    });
  }

  void _submitTest() {
    _timer.cancel();
    // TODO: Implement submit logic and move to result screen
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Submitted'),
        content: Text('You answered ${selectedOptions.where((element) => element != null).length} questions.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  void _selectOption(int index) {
    setState(() {
      selectedOptions[currentQuestionIndex] = index;
    });
  }

  void _onMarkForReviewToggle(bool value) {
    setState(() {
      markedForReview[currentQuestionIndex] = value;
      isMarkForReview = value;
    });
  }

  void _onQuestionSelected(int index) {
    setState(() {
      currentQuestionIndex = index;
      isMarkForReview = markedForReview[index];
    });
  }

  void _toggleLanguage(bool value) {
    setState(() {
      isHindi = value;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _onQuestionSelected(currentQuestionIndex + 1);
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      _onQuestionSelected(currentQuestionIndex - 1);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final answeredCount = selectedOptions.where((element) => element != null).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.testType} - ${widget.exam.name}'),
        actions: [
          Row(
            children: [
              const Text('English'),
              Switch(value: isHindi, onChanged: _toggleLanguage),
              const Text('Hindi'),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TopBar(
              timeRemaining: timeRemaining,
              onSubmit: _submitTest,
              answeredCount: answeredCount,
              totalQuestions: questions.length,
              isMarkForReview: isMarkForReview,
              onMarkForReviewToggle: _onMarkForReviewToggle,
            ),
            const Divider(thickness: 2),
            Expanded(
              child: SingleChildScrollView(
                child: QuestionWidget(
                  question: question,
                  selectedOption: selectedOptions[currentQuestionIndex],
                  onOptionSelected: _selectOption,
                  isHindi: isHindi,
                ),
              ),
            ),
            const SizedBox(height: 20),
            QuestionPalette(
              questionCount: questions.length,
              currentIndex: currentQuestionIndex,
              answeredStatus: selectedOptions.map((e) => e != null).toList(),
              onQuestionSelected: _onQuestionSelected,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentQuestionIndex == 0 ? null : _previousQuestion,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentQuestionIndex == questions.length - 1 ? null : _nextQuestion,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
