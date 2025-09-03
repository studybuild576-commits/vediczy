import 'package:flutter/material.dart';
import 'dart:async'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSC MOCK TEST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // Aap apne custom font bhi use kar sakte hain
      ),
      home: CBTRealisticScreen(),
    );
  }
}

class CBTRealisticScreen extends StatefulWidget {
  @override
  _CBTRealisticScreenState createState() => _CBTRealisticScreenState();
}

class _CBTRealisticScreenState extends State<CBTRealisticScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'question': 'Which article of the Indian Constitution deals with Right to Equality?',
      'fileName': 'file1.pdf',
      'image': 'assets/images/file_icon.png',
      'options': ['Article 19', 'Article 21', 'Article 14', 'Article 370']
    },
    {
      'id': 2,
      'question': 'Who is the current President of India?',
      'fileName': 'president_bio.pdf',
      'image': 'assets/images/file_icon.png',
      'options': ['Ram Nath Kovind', 'Droupadi Murmu', 'APJ Abdul Kalam', 'Pranab Mukherjee']
    },
  ];

  int currentQ = 0;
  Map<int, String> answers = {};
  Map<int, bool> markedReview = {};
  late Timer timer;
  Duration timeLeft = Duration(minutes: 15);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (timeLeft.inSeconds == 0) {
        timer.cancel();
        showResult();
      } else {
        setState(() {
          timeLeft -= Duration(seconds: 1);
        });
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Test Finished!'),
        content: Text('Your answers: ${answers.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
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
        title: Text('SSC MOCK TEST', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            color: Colors.deepPurple.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTimerBadge(),
                Text(
                  'Q${currentQ + 1}/${questions.length}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File & Question Details
              Row(
                children: [
                  Image.asset('assets/images/file_icon.png', width: 40, height: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['fileName'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('Click to view', style: TextStyle(fontSize: 14, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Question Card
              buildQuestionCard('Q${currentQ + 1}: ${question['question']}'),
              SizedBox(height: 20),
              // Options
              ...question['options'].map<Widget>((opt) {
                return buildOption(opt, answers[question['id']] ?? '', (val) {
                  selectOption(val);
                });
              }).toList(),
              SizedBox(height: 20),
              // Mark for Review
              Row(
                children: [
                  Checkbox(
                    value: markedReview[question['id']] ?? false,
                    onChanged: (_) => toggleMark(),
                  ),
                  Text('Mark for Review', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 30),
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
        padding: EdgeInsets.all(20),
        child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget buildOption(String optionText, String groupValue, Function(String) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        value: optionText,
        groupValue: groupValue,
        onChanged: (val) => onChanged(val!),
        title: Text(optionText, style: TextStyle(fontSize: 16)),
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
          icon: Icon(Icons.arrow_back),
          label: Text('Previous'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade700,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: goNext,
          icon: Icon(Icons.arrow_forward),
          label: Text('Next'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: showResult,
          icon: Icon(Icons.check),
          label: Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ),
        Text(
          '${timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(timeLeft.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
