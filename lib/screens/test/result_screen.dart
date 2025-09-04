import 'package:flutter/material.dart';
import 'package:vediczy/models/result_model.dart';

class ResultScreen extends StatelessWidget {
  final TestResult result;
  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
        automaticallyImplyLeading: false, // Back button hatayein
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Test Completed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Your Score',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 10),
                      Text(
                        result.score.toStringAsFixed(2), // Score ko 2 decimal places tak dikhayein
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 30),
                      _buildResultRow('Total Questions:', '${result.totalQuestions}'),
                      _buildResultRow('Attempted:', '${result.attemptedQuestions}'),
                      _buildResultRow('Correct Answers:', '${result.correctAnswers}', color: Colors.green),
                      _buildResultRow('Incorrect Answers:', '${result.incorrectAnswers}', color: Colors.red),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                onPressed: () {
                  // User ko Home Screen par wapas bhejein
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Back to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
