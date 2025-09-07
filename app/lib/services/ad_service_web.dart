// File: app/lib/services/ad_service_web.dart
import 'package:flutter/material.dart';

// Dummy class with unique name
class WebRewardItem {
  final int amount;
  final String type;

  WebRewardItem({this.amount = 1, this.type = "web_reward"});
}

class AdService {
  dynamic get bannerAd => null;

  static Future<void> initialize() async {
    // Web par kuch nahi karna
  }

  void loadBannerAd() {}

  void loadInterstitialAd() {}

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    onAdDismissed();
  }
  
  void loadRewardedAd() {}

  void showRewardedAd({required Function(WebRewardItem) onUserEarnedReward}) {
    // Web par fake reward bhej dete hain
    onUserEarnedReward(WebRewardItem());
  }
}
