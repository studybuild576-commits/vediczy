// lib/services/ad_service_web.dart
import 'package:flutter/material.dart';

// Dummy RewardItem same नाम से बनाओ
class RewardItem {
  final int amount;
  final String type;

  RewardItem({this.amount = 0, this.type = "Web"});
}

class AdService {
  dynamic get bannerAd => null;

  static Future<void> initialize() async {}

  void loadBannerAd() {}
  void loadInterstitialAd() {}

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    onAdDismissed();
  }

  void loadRewardedAd() {}

  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
    // Web par kuch nahi, but dummy reward bhej do
    onUserEarnedReward(RewardItem(amount: 0, type: "web"));
  }
}
