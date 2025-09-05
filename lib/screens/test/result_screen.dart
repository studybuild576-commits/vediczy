import 'package:flutter/material.dart';
import 'package:vediczy/models/result_model.dart';
import 'package:vediczy/services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ResultScreen extends StatefulWidget {
  final TestResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    // स्क्रीन खुलते ही इनाम वाला विज्ञापन लोड करें
    _adService.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Result'),
        automaticallyImplyLeading: false, // Back बटन हटाएँ
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
                        widget.result.score.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 30),
                      _buildResultRow('Total Questions:', '${widget.result.totalQuestions}'),
                      _buildResultRow('Attempted:', '${widget.result.attemptedQuestions}'),
                      _buildResultRow('Correct Answers:', '${widget.result.correctAnswers}', color: Colors.green),
                      _buildResultRow('Incorrect Answers:', '${widget.result.incorrectAnswers}', color: Colors.red),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),

              // इनाम वाले विज्ञापन के लिए नया बटन
              ElevatedButton.icon(
                icon: Icon(Icons.video_collection),
                label: Text('Watch Ad to See Solutions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  _adService.showRewardedAd(onUserEarnedReward: (RewardItem reward) {
                     print("Reward earned: ${reward.amount} ${reward.type}");
                     // इनाम मिलने पर उपयोगकर्ता को एक संदेश दिखाएँ
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Reward Earned! Solutions Unlocked.')),
                     );
                  });
                },
              ),
              
              SizedBox(height: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                onPressed: () {
                  // उपयोगकर्ता को Home Screen पर वापस भेजें
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
