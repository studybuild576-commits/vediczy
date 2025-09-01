import 'package:flutter/material.dart';
import 'package:vediczy/screens/splash_screen.dart'; // Ensure correct import

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
