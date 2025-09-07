import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:vediczy/models/result_model.dart';
import 'package:vediczy/services/ad_service.dart';
import 'package:vediczy/services/ad_service_web.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gads;

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
    _adService.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Result'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Test Completed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),

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
                      const SizedBox(height: 10),
                      Text(
                        widget.result.score.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Divider(height: 30),
                      _buildResultRow(
                          'Total Questions:', '${widget.result.totalQuestions}'),
                      _buildResultRow(
                          'Attempted:', '${widget.result.attemptedQuestions}'),
                      _buildResultRow('Correct Answers:',
                          '${widget.result.correctAnswers}',
                          color: Colors.green),
                      _buildResultRow('Incorrect Answers:',
                          '${widget.result.incorrectAnswers}',
                          color: Colors.red),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.video_collection),
                label: const Text('Watch Ad to See Solutions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  if (kIsWeb) {
                    // ✅ Web reward dummy
                    _adService.showRewardedAd(
                      onUserEarnedReward: (WebRewardItem reward) {
                        print("Web reward earned: ${reward.amount} ${reward.type}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Web Reward Earned! Solutions Unlocked.')),
                        );
                      },
                    );
                  } else {
                    // ✅ Mobile reward real
                    _adService.showRewardedAd(
                      onUserEarnedReward: (gads.RewardItem reward) {
                        print("Reward earned: ${reward.amount} ${reward.type}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reward Earned! Solutions Unlocked.')),
                        );
                      },
                    );
                  }
                },
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
