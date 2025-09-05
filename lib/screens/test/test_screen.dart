import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vediczy/models/question_model.dart';
import 'package:vediczy/models/result_model.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/test/result_screen.dart';
import 'package:vediczy/services/firestore_service.dart'; // नया इम्पोर्ट

enum QuestionStatus { notVisited, notAnswered, answered, markedForReview, answeredAndMarked }

class TestScreen extends StatefulWidget {
  final Test test;
  const TestScreen({super.key, required this.test});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<List<Question>> _questionsFuture;
  List<Question> _questionsList = [];
  late List<QuestionStatus> _questionStatuses;
  late List<int?> _selectedOptions;
  late PageController _pageController;
  int _currentIndex = 0;

  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    // YAHAN BADLAAV KIYA GAYA HAI
    _questionsFuture = FirestoreService().getQuestionsForTest(widget.test.id);
    _pageController = PageController();
    _remainingSeconds = widget.test.durationInMinutes * 60;
    _startTimer();

    _questionsFuture.then((questions) {
      setState(() {
        _questionsList = questions;
        _questionStatuses = List.generate(questions.length, (index) => QuestionStatus.notVisited);
        _selectedOptions = List.generate(questions.length, (index) => null);
        if (_questionStatuses.isNotEmpty) {
          _questionStatuses[0] = QuestionStatus.notAnswered;
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() { _remainingSeconds--; });
      } else {
        _timer.cancel();
        _calculateAndNavigateToResult();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (_questionStatuses[index] == QuestionStatus.notVisited) {
        _questionStatuses[index] = QuestionStatus.notAnswered;
      }
    });
  }

  void _saveAndNext() {
      if(_selectedOptions[_currentIndex] != null) {
          _questionStatuses[_currentIndex] = QuestionStatus.answered;
      } else {
          _questionStatuses[_currentIndex] = QuestionStatus.notAnswered;
      }

      if (_currentIndex < _questionsList.length - 1) {
          _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
          _submitTest();
      }
  }
  
  void _submitTest() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Submit Test'),
        content: Text('Are you sure you want to submit the test?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _calculateAndNavigateToResult();
            },
          ),
        ],
      ),
    );
  }

  void _calculateAndNavigateToResult() {
    _timer.cancel();
    int total = _questionsList.length;
    int attempted = 0;
    int correct = 0;
    int incorrect = 0;
    double score = 0.0;

    for (int i = 0; i < total; i++) {
      if (_selectedOptions[i] != null) {
        attempted++;
        if (_selectedOptions[i] == _questionsList[i].correctOptionIndex) {
          correct++;
          score += 2;
        } else {
          incorrect++;
          score -= 0.5;
        }
      }
    }

    final result = TestResult(
      totalQuestions: total,
      attemptedQuestions: attempted,
      correctAnswers: correct,
      incorrectAnswers: incorrect,
      score: score,
    );
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Time Left: ${_formatDuration(_remainingSeconds)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: _submitTest,
            child: Text('SUBMIT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      endDrawer: _buildQuestionPalette(),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Could not load questions."));
          }
          final questions = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: questions.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}/${questions.length}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 10),
                            Text(
                              question.questionText,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            ...List.generate(question.options.length, (optionIndex) {
                              return RadioListTile<int>(
                                title: Text(question.options[optionIndex]),
                                value: optionIndex,
                                groupValue: _selectedOptions[index],
                                onChanged: (value) {
                                  setState(() { _selectedOptions[index] = value; });
                                },
                              );
                            })
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(onPressed: (){}, child: Text("Mark for Review")),
                    ElevatedButton(onPressed: (){
                        setState(() { _selectedOptions[_currentIndex] = null; });
                    }, child: Text("Clear Response")),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: _saveAndNext,
                      child: Text("Save & Next")
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionPalette() {
    return Drawer(
      child: SafeArea(
        child: GridView.builder(
            padding: EdgeInsets.all(12),
            itemCount: _questionsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                    _pageController.jumpToPage(index);
                    Navigator.pop(context);
                },
                child: Text('${index + 1}'),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8),
                  backgroundColor: _getQuestionColor(index),
                  foregroundColor: Colors.white,
                ),
              );
            },
          ),
      ),
    );
  }

  Color _getQuestionColor(int index) {
    if (index >= _questionStatuses.length) return Colors.grey;
    switch (_questionStatuses[index]) {
        case QuestionStatus.answered: return Colors.green;
        case QuestionStatus.notAnswered: return Colors.red;
        case QuestionStatus.markedForReview: return Colors.purple;
        case QuestionStatus.answeredAndMarked: return Colors.purpleAccent;
        case QuestionStatus.notVisited: return Colors.grey;
    }
  }
}
