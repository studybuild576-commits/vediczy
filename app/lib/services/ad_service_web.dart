import 'package:flutter/material.dart';

// Dummy class, taaki code mein error na aaye
class WebRewardItem {
  final int amount;
  final String type;

  WebRewardItem({this.amount = 0, this.type = "Web"});
}

class AdService {
  // Web par koi banner nahi hai, isliye null bhej rahe hain
  dynamic get bannerAd => null;

  static Future<void> initialize() async {
    // Web par kuch nahi karna
  }

  void loadBannerAd() {
    // Web par kuch nahi karna
  }

  void loadInterstitialAd() {
    // Web par kuch nahi karna
  }

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    // Ad na hone par seedhe aage badh jaayein
    onAdDismissed();
  }

  void loadRewardedAd() {
    // Web par kuch nahi karna
  }

  void showRewardedAd({required Function(WebRewardItem) onUserEarnedReward}) {
    // Web par ad nahi, seedhe dummy reward bhej do
    onUserEarnedReward(WebRewardItem());
  }
}
