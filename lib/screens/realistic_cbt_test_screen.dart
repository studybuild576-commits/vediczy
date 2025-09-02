import 'dart:async';
import 'package:flutter/material.dart';

class RealisticCBTTestScreen extends StatefulWidget {
  const RealisticCBTTestScreen({super.key});

  @override
  _RealisticCBTTestScreenState createState() => _RealisticCBTTestScreenState();
}

class _RealisticCBTTestScreenState extends State<RealisticCBTTestScreen> {
  int currentQuestionIndex = 0;
  bool isHindi = false;
  bool markForReview = false;

  late Timer _timer;
  Duration timeLeft = const Duration(minutes: 30);

  final List<String> questions = [
    'What is 2 + 2?',
    'What is the capital of India?',
  ];

  final List<List<String>> options = [
    ['1', '2', '3', '4'],
    ['New Delhi', 'Mumbai', 'Chennai', 'Kolkata'],
  ];

  List<int?> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(questions.length, null);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.inSeconds == 0) {
        timer.cancel();
        _submitTest();
      } else {
        setState(() {
          timeLeft = timeLeft - const Duration(seconds: 1);
        });
      }
    });
  }

  void _submitTest() {
    _timer.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Submitted'),
        content: Text('You answered ${selectedOptions.where((e) => e != null).length} questions.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final min = duration.inMinutes.toString().padLeft(2, '0');
    final sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  void _onOptionSelected(int optionIndex) {
    setState(() {
      selectedOptions[currentQuestionIndex] = optionIndex;
    });
  }

  void _toggleLanguage(bool value) {
    setState(() {
      isHindi = value;
    });
  }

  void _toggleMarkForReview(bool value) {
    setState(() {
      markForReview = value;
    });
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      markForReview = false; // Adjust as required for actual mark for review tracking
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D47A1); // Dark Blue
    final answeredColor = const Color(0xFF4CAF50); // Green
    final reviewColor = const Color(0xFFFFA000); // Orange Amber
    final notVisitedColor = const Color(0xFF9E9E9E); // Grey

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sectional Test'),
            Row(
              children: [
                const Text('English', style: TextStyle(fontSize: 14)),
                Switch(
                    value: isHindi,
                    onChanged: _toggleLanguage,
                    activeColor: primaryColor),
                const Text('Hindi', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer, Answered count, Mark for Review toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Left: ${_formatTime(timeLeft)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Answered: ${selectedOptions.where((o) => o != null).length} / ${questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text('Mark for Review'),
                    Switch(
                      value: markForReview,
                      onChanged: _toggleMarkForReview,
                      activeColor: reviewColor,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 12),
            Text(
              questions[currentQuestionIndex],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
                    itemCount: options[currentQuestionIndex].length,
                    itemBuilder: (context, index) {
                      final isSelected =
                          selectedOptions[currentQuestionIndex] == index;
                      return Card(
                        elevation: 2,
                        shadowColor: primaryColor.withOpacity(0.2),
                        color:
                            isSelected ? primaryColor.withOpacity(0.2) : null,
                        child: RadioListTile<int>(
                          value: index,
                          groupValue: selectedOptions[currentQuestionIndex],
                          activeColor: primaryColor,
                          title: Text(
                            options[currentQuestionIndex][index],
                            style: TextStyle(
                                fontSize: 18,
                                color: isSelected ? primaryColor : Colors.black87),
                          ),
                          onChanged: (val) {
                            if (val != null) _onOptionSelected(val);
                          },
                        ),
                      );
                    })),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(questions.length, (index) {
                final bool answered = selectedOptions[index] != null;
                Color circleColor;
                if (index == currentQuestionIndex) {
                  circleColor = primaryColor;
                } else if (markForReview && index == currentQuestionIndex) {
                  circleColor = reviewColor;
                } else if (answered) {
                  circleColor = answeredColor;
                } else {
                  circleColor = notVisitedColor;
                }
                return GestureDetector(
                  onTap: () => _goToQuestion(index),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: circleColor,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed:
                      currentQuestionIndex == 0 ? null : () => _goToQuestion(currentQuestionIndex - 1),
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: currentQuestionIndex == questions.length - 1
                      ? null
                      : () => _goToQuestion(currentQuestionIndex + 1),
                  child: const Text('Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
