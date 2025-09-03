import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSC MOCK TEST',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Arial',
      ),
      // Here, we call the CBTRealisticScreen class.
      home: const CBTRealisticScreen(),
    );
  }
}

class CBTRealisticScreen extends StatefulWidget {
  const CBTRealisticScreen({Key? key}) : super(key: key);

  @override
  _CBTRealisticScreenState createState() => _CBTRealisticScreenState();
}

class _CBTRealisticScreenState extends State<CBTRealisticScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'question': 'Which article of the Indian Constitution deals with Right to Equality?',
      'fileName': 'file1.pdf',
      'options': ['Article 19', 'Article 21', 'Article 14', 'Article 370']
    },
    {
      'id': 2,
      'question': 'Who is the current President of India?',
      'fileName': 'president_bio.pdf',
      'options': ['Ram Nath Kovind', 'Droupadi Murmu', 'APJ Abdul Kalam', 'Pranab Mukherjee']
    },
  ];

  int currentQ = 0;
  Map<int, String> answers = {};
  Map<int, bool> markedReview = {};
  late Timer timer;
  Duration timeLeft = const Duration(minutes: 15);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft.inSeconds == 0) {
        timer.cancel();
        showResult();
      } else {
        if (mounted) {
          setState(() {
            timeLeft -= const Duration(seconds: 1);
          });
        }
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Finished!'),
        content: Text('Your answers: ${answers.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String getFormattedTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(timeLeft.inMinutes.remainder(60));
    final seconds = twoDigits(timeLeft.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void selectOption(String option) {
    setState(() {
      answers[questions[currentQ]['id']] = option;
    });
  }

  void goNext() {
    if (currentQ < questions.length - 1) {
      setState(() {
        currentQ++;
      });
    }
  }

  void goPrevious() {
    if (currentQ > 0) {
      setState(() {
        currentQ--;
      });
    }
  }

  void toggleMark() {
    int qID = questions[currentQ]['id'];
    setState(() {
      markedReview[qID] = !(markedReview[qID] ?? false);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'SSC MOCK TEST',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          buildTimerBadge(),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File & Question Details (Image.asset hata diya gaya hai)
              Row(
                children: [
                  const Icon(Icons.description, size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['fileName'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text('Click to view', style: TextStyle(fontSize: 14, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Question Card
              buildQuestionCard('Q${currentQ + 1}: ${question['question']}'),
              const SizedBox(height: 20),
              // Options
              ...question['options'].map<Widget>((opt) {
                return buildOption(opt, answers[question['id']] ?? '', (val) {
                  selectOption(val);
                });
              }).toList(),
              const SizedBox(height: 20),
              // Mark for Review
              Row(
                children: [
                  Checkbox(
                    value: markedReview[question['id']] ?? false,
                    onChanged: (_) => toggleMark(),
                  ),
                  const Text('Mark for Review', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 30),
              // Navigation Buttons
              buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionCard(String text) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget buildOption(String optionText, String groupValue, Function(String) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: optionText,
        groupValue: groupValue,
        onChanged: (val) => onChanged(val!),
        title: Text(optionText, style: const TextStyle(fontSize: 16)),
        activeColor: Colors.deepPurple,
      ),
    );
  }

  Widget buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: goPrevious,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Previous'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: goNext,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Next'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: showResult,
          icon: const Icon(Icons.check),
          label: const Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget buildTimerBadge() {
    double progress = timeLeft.inSeconds / (15 * 60);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ),
        Text(
          getFormattedTime(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
